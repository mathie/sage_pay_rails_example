class Payment < ActiveRecord::Base
  attr_accessor :response

  belongs_to :currency
  belongs_to :billing_address,  :class_name => "Address", :dependent => :destroy
  belongs_to :delivery_address, :class_name => "Address", :dependent => :destroy
  has_many :sage_pay_transactions, :dependent => :destroy
  has_one :latest_sage_pay_transaction, :class_name => "SagePayTransaction", :order => "created_at DESC"
  has_one :latest_authenticated_sage_pay_transaction, :class_name => "SagePayTransaction", :order => "created_at DESC", :conditions => { :status => 'authenticated', :transaction_type => 'authenticate' }
  has_one :latest_authorised_sage_pay_transaction,    :class_name => "SagePayTransaction", :order => "created_at DESC", :conditions => { :status => 'authorised',    :transaction_type => 'authorise'    }
  has_one :latest_cancelled_sage_pay_transaction,     :class_name => "SagePayTransaction", :order => "created_at DESC", :conditions => { :status => 'cancelled',     :transaction_type => 'cancel'       }

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :delivery_address, :reject_if => lambda { |attributes| attributes.all? { |k, v| v.blank? } }

  validates_presence_of :description, :currency_id, :amount
  validates_length_of :description, :maximum => 100, :allow_blank => true
  validates_numericality_of :amount, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => 100_000, :allow_blank => true


  def pay
    register(:payment)
  end

  def defer
    register(:deferred)
  end

  def authenticate
    register(:authenticate)
  end

  def register(tx_type)
    if complete? || in_progress?
      raise RuntimeError, "Sage Pay transaction has already been registered for this payment!"
    end

    sage_pay_registration = SagePay::Server.registration(
      :tx_type => tx_type,
      :description => description,
      :currency => currency.iso_code,
      :amount => amount,
      :billing_address => billing_address.to_sage_pay_address
    )
    sage_pay_registration.delivery_address = delivery_address.to_sage_pay_address if delivery_address.present?

    self.response = sage_pay_registration.run!
    if response.ok?
      sage_pay_transactions.create!(
        :transaction_type      => sage_pay_registration.tx_type.to_s,
        :vendor                => sage_pay_registration.vendor,
        :our_transaction_code  => sage_pay_registration.vendor_tx_code,
        :security_key          => response.security_key,
        :sage_transaction_code => response.vps_tx_id
      )

      response.next_url
    else
      nil
    end
  end

  def release
    if deferred?
      sage_pay_release = SagePay::Server.release(
         :vendor_tx_code => latest_sage_pay_transaction.our_transaction_code,
         :vps_tx_id      => latest_sage_pay_transaction.sage_transaction_code,
         :security_key   => latest_sage_pay_transaction.security_key,
         :tx_auth_no     => latest_sage_pay_transaction.authorisation_code,
         :release_amount => amount
      )

      self.response = sage_pay_release.run!
      if response.ok?
        sage_pay_transactions.create!(
          :status           => "released",
          :transaction_type => sage_pay_release.tx_type.to_s
        )
      else
        false
      end
    end
  end

  def abort
    if deferred?
      sage_pay_abort = SagePay::Server.abort(
         :vendor_tx_code => latest_sage_pay_transaction.our_transaction_code,
         :vps_tx_id      => latest_sage_pay_transaction.sage_transaction_code,
         :security_key   => latest_sage_pay_transaction.security_key,
         :tx_auth_no     => latest_sage_pay_transaction.authorisation_code
      )

      self.response = sage_pay_abort.run!
      if response.ok?
        sage_pay_transactions.create!(
          :status           => "aborted",
          :transaction_type => sage_pay_abort.tx_type.to_s
        )
      else
        false
      end
    end
  end

  def refund
    if paid? || released?
      sage_pay_refund = SagePay::Server.refund(
        :amount              => amount,
        :currency            => currency.iso_code,
        :description         => "Refund: #{description}",
        :related_transaction => latest_sage_pay_transaction.to_related_transaction
      )

      self.response = sage_pay_refund.run!
      if response.ok?
        sage_pay_transactions.create!(
          :status                => "refunded",
          :transaction_type      => sage_pay_refund.tx_type.to_s,
          :authorisation_code    => response.tx_auth_no,
          :sage_transaction_code => response.vps_tx_id
        )
      else
        false
      end
    end
  end

  def authorise
    if authenticated? || authorised?
      sage_pay_authorise = SagePay::Server.authorise(
        :amount              => amount,
        :description         => "Authorise: #{description}",
        :related_transaction => latest_authenticated_sage_pay_transaction.to_related_transaction
      )

      self.response = sage_pay_authorise.run!
      if response.ok?
        sage_pay_transactions.create!(
          :status                => "authorised",
          :transaction_type      => sage_pay_authorise.tx_type.to_s,
          :our_transaction_code  => sage_pay_authorise.vendor_tx_code,
          :sage_transaction_code => response.vps_tx_id,
          :authorisation_code    => response.tx_auth_no,
          :security_key          => response.security_key
        )
      else
        false
      end
    end
  end

  def repeat
    if authorised?
      sage_pay_repeat = SagePay::Server.repeat(
        :amount              => amount,
        :currency            => currency.iso_code,
        :description         => "Repeat: #{description}",
        :related_transaction => latest_authorised_sage_pay_transaction.to_related_transaction
      )

      self.response = sage_pay_repeat.run!
      if response.ok?
        sage_pay_transactions.create!(
          :status                => "repeated",
          :transaction_type      => sage_pay_repeat.tx_type.to_s,
          :our_transaction_code  => sage_pay_repeat.vendor_tx_code,
          :sage_transaction_code => response.vps_tx_id,
          :authorisation_code    => response.tx_auth_no,
          :security_key          => response.security_key,
          :avs_cv2_matched       => response.avs_cv2_matched?,
          :address_matched       => response.address_matched?,
          :post_code_matched     => response.post_code_matched?,
          :cv2_matched           => response.cv2_matched?
        )
      else
        false
      end
    end
  end

  def cancel
    if authorised?
      sage_pay_cancel = SagePay::Server.cancel(
        :vps_tx_id      => latest_authenticated_sage_pay_transaction.sage_transaction_code,
        :vendor_tx_code => latest_authenticated_sage_pay_transaction.our_transaction_code,
        :security_key   => latest_authenticated_sage_pay_transaction.security_key
      )

      self.response = sage_pay_cancel.run!
      if response.ok?
        sage_pay_transactions.create!(
          :status                => "cancelled",
          :transaction_type      => sage_pay_cancel.tx_type.to_s
        )
      else
        false
      end
    end
  end

  def started?
    latest_sage_pay_transaction.present?
  end

  def complete?
    started? && latest_sage_pay_transaction.complete?
  end

  def paid?
    complete? && latest_sage_pay_transaction.paid?
  end

  def deferred?
    complete? && latest_sage_pay_transaction.deferred?
  end

  def released?
    complete? && latest_sage_pay_transaction.released?
  end

  def aborted?
    complete? && latest_sage_pay_transaction.aborted?
  end

  def refunded?
    complete? && latest_sage_pay_transaction.refunded?
  end

  def authenticated?
    latest_authenticated_sage_pay_transaction.present? && !cancelled?
  end

  def authorised?
    latest_authorised_sage_pay_transaction.present? && !cancelled?
  end

  def cancelled?
    latest_cancelled_sage_pay_transaction.present?
  end

  def failed?
    complete? && latest_sage_pay_transaction.failed?
  end

  def in_progress?
    started? && !complete?
  end

  def transaction_code
    latest_sage_pay_transaction.present? ? latest_sage_pay_transaction.our_transaction_code : nil
  end
end

class Payment < ActiveRecord::Base
  belongs_to :currency
  belongs_to :billing_address,  :class_name => "Address", :dependent => :destroy
  belongs_to :delivery_address, :class_name => "Address", :dependent => :destroy
  has_one :sage_pay_transaction, :dependent => :destroy

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :delivery_address, :reject_if => lambda { |attributes| attributes.all? { |k, v| v.blank? } }

  validates_presence_of :description, :currency_id, :amount
  validates_length_of :description, :maximum => 100, :allow_blank => true
  validates_numericality_of :amount, :greater_than_or_equal_to => 0.01, :less_than_or_equal_to => 100_000, :allow_blank => true

  def register
    if sage_pay_transaction.present?
      raise RuntimeError, "Sage Pay transaction has already been registered for this payment!"
    end

    response = sage_pay_payment.register!
    if response.ok?
      svd = sage_pay_payment.signature_verification_details
      create_sage_pay_transaction(
        :vendor_tx_code => svd.vendor_tx_code,
        :vendor         => svd.vendor,
        :vps_tx_id      => svd.vps_tx_id,
        :security_key   => svd.security_key
      )

      response.next_url
    else
      nil
    end
  end

  def sage_pay_payment
    if @sage_pay_payment.nil?
      @sage_pay_payment = SagePay::Server.payment(
        :description => description,
        :currency => currency.iso_code,
        :amount => amount,
        :billing_address => billing_address.to_sage_pay_address
      )

      @sage_pay_payment.delivery_address = delivery_address.to_sage_pay_address if delivery_address.present?
    end
    @sage_pay_payment
  end
end

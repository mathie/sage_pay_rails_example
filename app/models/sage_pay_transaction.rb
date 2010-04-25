class SagePayTransaction < ActiveRecord::Base
  attr_accessor :notification

  belongs_to :payment

#  validates_presence_of :vendor, :security_key, :transaction_type, :payment_id, :our_transaction_code, :sage_transaction_code

#  validates_presence_of :authorisation_code, :card_type, :last_4_digits, :if => :success?

  def self.record_notification_from_params(params)
    sage_pay_transaction = nil
    notification = SagePay::Server::Notification.from_params(params) do |attributes|
      sage_pay_transaction = find(:first, :conditions => { :our_transaction_code => attributes[:vendor_tx_code], :sage_transaction_code => attributes[:vps_tx_id] })
      SagePay::Server::SignatureVerificationDetails.new(sage_pay_transaction.vendor, sage_pay_transaction.security_key) if sage_pay_transaction.present?
    end

    sage_pay_transaction.update_attributes_from_notification!(notification) if sage_pay_transaction.present?

    sage_pay_transaction
  end

  def response(redirect_url)
    notification.response(redirect_url) if notification.present?
  end

  def update_attributes_from_notification!(notification)
    self.notification = notification

    if notification.valid_signature?
      update_attributes!(
        :status             => notification.status.to_s,
        :authorisation_code => notification.tx_auth_no,
        :avs_cv2_matched    => notification.avs_cv2_matched?,
        :address_matched    => notification.address_matched?,
        :post_code_matched  => notification.post_code_matched?,
        :cv2_matched        => notification.cv2_matched?,
        :gift_aid           => notification.gift_aid,
        :threed_secure_ok   => notification.threed_secure_status_ok?,
        :card_type          => notification.card_type.to_s.humanize,
        :last_4_digits      => notification.last_4_digits
      )
    else
      update_attributes!(:status => "tampered")
    end
  end

  def to_related_transaction
    SagePay::Server.related_transaction(
      :vps_tx_id      => sage_transaction_code,
      :vendor_tx_code => our_transaction_code,
      :security_key   => security_key,
      :tx_auth_no     => authorisation_code
    )
  end

  def complete?
    status.present?
  end

  def success?
    complete? && status == "ok"
  end

  def paid?
    success? && transaction_type == "payment"
  end

  def deferred?
    success? && transaction_type == "deferred"
  end

  def released?
    complete? && status == "released" && transaction_type == "deferred"
  end

  def aborted?
    complete? && status == "aborted" && transaction_type == "deferred"
  end

  def refunded?
    complete? && status == "refunded"
  end

  def authenticated?
    complete? && ["authenticated", "registered"].include?(status) && transaction_type == "authenticate"
  end

  def authorised?
    complete? && status == "authorised" && transaction_type == "authorise"
  end

  def failed?
    complete? && !success? && !authenticated?
  end
end

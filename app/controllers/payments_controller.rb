class PaymentsController < InheritedResources::Base
  def resource
    returning super do |payment|
      payment.build_billing_address if payment.billing_address.blank?
      payment.build_delivery_address if payment.delivery_address.blank?
    end
  end
end
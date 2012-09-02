class NotificationsController < InheritedResources::Base
  skip_before_filter :verify_authenticity_token, :only => [ :create ]
  actions :create

  def create
    #(See SagePayTransaction model)
    # The following takes the notification params returned from SagePay
    # it saves them in the database table: Sage_Pay_Transactions
    # and returns the notification params as sage_pay_transaction
    sage_pay_transaction = SagePayTransaction.record_notification_from_params(params)
    #(See SagePayTransaction model)
    # Takes notification params from above
    # The following returns a response to SagePay with a URL to payment/action where action is pay,defer,release etc (from SagePayTransactionsController)
    render :text => sage_pay_transaction.response(payment_url(sage_pay_transaction.payment))
  rescue Exception => e
    render :text => SagePay::Server::NotificationResponse.new(:status => :error, :status_detail => "An error occurred: #{e.message}", :redirect_url => payments_url).response
  end
end

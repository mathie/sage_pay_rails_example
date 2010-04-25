class NotificationsController < InheritedResources::Base
  skip_before_filter :verify_authenticity_token, :only => [ :create ]
  actions :create

  def create
    response = SagePayTransaction.record_notification_from_params(params)
    render :text => response.inspect
  end
end

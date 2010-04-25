class NotificationsController < InheritedResources::Base
  actions :create

  def create
    response = SagePayTransaction.record_notification_from_params(params)
    render :text => reponse.response
  end
end
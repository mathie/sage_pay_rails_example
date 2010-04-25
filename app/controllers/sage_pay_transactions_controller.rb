class SagePayTransactionsController < InheritedResources::Base
  belongs_to :payment
  actions :create

  def create
    next_url = parent.register
    if next_url.present?
      redirect_to next_url
    else
      flash[:error] = "There was a problem redirecting to SagePay for payment: #{parent.response.status} - #{parent.response.status_detail}"
      redirect_to parent_path
    end
  end
end

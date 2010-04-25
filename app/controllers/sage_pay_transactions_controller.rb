class SagePayTransactionsController < InheritedResources::Base
  belongs_to :payment
  actions :create

  def create
    tx_type = params[:tx_type] || "payment"
    next_url = case tx_type
      when "payment"
        parent.pay
      when "deferred"
        parent.defer
      when "authenticate"
        parent.authenticate
      else
        flash[:error] = "Invalid transaction type"
        redirect_to parent_path
        return false
    end

    if next_url.present?
      redirect_to next_url
    else
      flash[:error] = "There was a problem redirecting to SagePay for payment: #{parent.response.status} - #{parent.response.status_detail}"
      redirect_to parent_path
    end
  end
end

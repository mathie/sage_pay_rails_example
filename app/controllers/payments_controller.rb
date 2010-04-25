class PaymentsController < InheritedResources::Base

  def release
    if resource.release
      flash[:notice] = "Deferred payment successfully released."
    else
      flash[:error] = "Deferred payment failed to release: #{resource.response.status} - #{resource.response.status_detail}"
    end
    redirect_to resource
  end

  def abort
    if resource.abort
      flash[:notice] = "Deferred payment successfully aborted."
    else
      flash[:error] = "Deferred payment failed to abort: #{resource.response.status} - #{resource.response.status_detail}"
    end
    redirect_to resource
  end

  def refund
    if resource.refund
      flash[:notice] = "Payment successfully refunded."
    else
      flash[:error] = "Payment failed to refund: #{resource.response.status} - #{resource.response.status_detail}"
    end
    redirect_to resource
  end

  def repeat
    if resource.repeat
      flash[:notice] = "Payment successfully repeated."
    else
      flash[:error] = "Payment failed to repeat: #{resource.response.status} - #{resource.response.status_detail}"
    end
    redirect_to resource
  end

  def authorise
    if resource.authorise
      flash[:notice] = "Payment successfully authorised."
    else
      flash[:error] = "Payment failed to authorise: #{resource.response.status} - #{resource.response.status_detail}"
    end
    redirect_to resource
  end
end

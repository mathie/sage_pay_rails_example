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
end

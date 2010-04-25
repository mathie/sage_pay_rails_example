class PaymentsController < InheritedResources::Base

  def release
    if resource.release
      flash[:notice] = "Deferred payment successfully released."
    else
      flash[:error] = "Deferred payment failed to release."
    end
    redirect_to resource
  end
end

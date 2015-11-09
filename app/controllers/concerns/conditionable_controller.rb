module ConditionableController
  def conditionable_init(resource, path_for_redirect)
    @resource = resource 
    @path_for_redirect = path_for_redirect
  end

  def activate
    @resource.set_condition(:active)
    @resource.save
    respond_to do |format|
      format.html{ redirect_to @path_for_redirect }
      format.json{ render :nothing => true, :status => 200 }
    end
  end

  def stop
    @resource.set_condition(:stoped)
    @resource.save
    respond_to do |format|
      format.html{ redirect_to @path_for_redirect }
      format.json{ render :nothing => true, :status => 200 }
    end
  end

  def destroy
    @resource.set_condition(:removed)
    @resource.save
    respond_to do |format|
      format.html{ redirect_to @path_for_redirect }
      format.json{ render :nothing => true, :status => 200 }
    end
  end

end
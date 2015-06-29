module ConditionableController
  def conditionable_init(resource, path_for_redirect)
	@resource = resource 
	@path_for_redirect = path_for_redirect
  end

  def activate
    @resource.set_condition(:active)
    @resource.save
    redirect_to @path_for_redirect
  end

  def stop
    @resource.set_condition(:stoped)
    @resource.save
    redirect_to @path_for_redirect
  end

  def destroy
    @resource.set_condition(:removed)
    @resource.save
    redirect_to @path_for_redirect
  end

end
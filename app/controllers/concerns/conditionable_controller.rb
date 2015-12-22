module ConditionableController
  CONDITIONS = {:active=>'activate', :stoped=>'stop', :removed=>'destroy'}

  def conditionable_init(resource, path_for_redirect)
    @resource = resource 
    @path_for_redirect = path_for_redirect
  end

  CONDITIONS.each do |condition, action|
    define_method "#{action}" do
      @resource.set_condition(condition)
      standatd_response
    end
  end

  private
    def standatd_response
      @resource.save
      respond_to do |format|
        format.html{ redirect_to @path_for_redirect }
        format.json{ render :nothing => true, :status => 200 }
      end
    end
end
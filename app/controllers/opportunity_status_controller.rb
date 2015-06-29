class OpportunityStatusController < StateController
  skip_load_and_authorize_resource
  
  private
  def init_resource
    @resource = Opportunity.find(params[:id])
  end

  def render_path_string
    "/opportunities/index.js"
  end

  def init_resources
    @stage = params[:stage]    
    if @parent_company then
      @opportunities = @parent_company.opportunities
    elsif @parent_person then
      @opportunities = @parent_person.opportunities
    else
      @opportunities = @stage ? Opportunity.by_stage(@stage.to_sym, current_user) : Opportunity.by_user(current_user)      
    end
  end
end

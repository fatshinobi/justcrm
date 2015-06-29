class StateController < ApplicationController
  before_action :init_status, only: [:set_status]
  before_action :init_resource, only: [:set_status]
  before_action :init_parents, only: [:set_status]
  before_action :init_resources, only: [:set_status]

  def set_status
    begin
      @resource.set_status @status_name.to_sym
      @resource.save
    rescue IndexError
      flash[:notice] = 'Status is not valid!'
    end

    respond_to do |format|
      format.html do
        redirect_to @resource
      end
      format.js do
        render render_path_string
      end
    end

  end

  private

  def init_status
    @status_name = params[:status_name]
  end

  def init_parents
    @parent_company = Company.find(params[:company_parent_id]) if params[:company_parent_id]
    @parent_person = Person.find(params[:person_parent_id]) if params[:person_parent_id]
    @parent_opportunity = Opportunity.find(params[:opportunity_parent_id]) if params[:opportunity_parent_id]
  end
end
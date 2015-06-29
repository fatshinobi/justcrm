class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:edit, :update]
  before_action :set_parent, only: [:edit, :update, :new, :create]
  respond_to :html, :js

  def new
    @appointment = Appointment.new(user: current_user)
	  respond_with(@appointment)
  end

  def edit
  end

  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      parent_redirect    
    else
      render :new
    end
  end

  def update
    if @appointment.update(appointment_params)
      parent_redirect
    else
      render :edit
    end
  end

  private

  def parent_redirect
    #byebug
    if @parent
      redirect_to @parent
    else
      redirect_to root_path
    end
  end

  def set_appointment
      @appointment = Appointment.find(params[:id])
  end

  def set_parent
    if params[:company_parent_id]
      @parent_company = Company.find(params[:company_parent_id])
      @parent = @parent_company
    elsif params[:person_parent_id]
      @parent_person = Person.find(params[:person_parent_id])
      @parent = @parent_person
    elsif params[:opportunity_parent_id]
      @parent_opportunity = Opportunity.find(params[:opportunity_parent_id])
      @parent = @parent_opportunity
    end
  end

  def appointment_params
    params.require(:appointment).permit(:body, :when, :person_id, :company_id, :opportunity_id, :communication_type, :user_id, :company_parent_id, :person_parent_id, :opportunity_parent_id)
  end

end

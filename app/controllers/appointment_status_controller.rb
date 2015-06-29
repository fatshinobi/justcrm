class AppointmentStatusController < StateController
  skip_load_and_authorize_resource
  
  private
  def init_resource
    @resource = Appointment.find(params[:id])
  end

  def render_path_string
    "/appointments/index.js"
  end

  def init_resources
    if @parent_company then
      @appointments = @parent_company.appointments
    elsif @parent_person then
      @appointments = @parent_person.appointments
    elsif @parent_opportunity then
      @appointments = @parent_opportunity.appointments
    else
      @appointments = Appointment.current(Date.current, current_user)
    end
  end
end

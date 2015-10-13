class WorkspacesController < ApplicationController
  skip_load_and_authorize_resource

  def index
    @appointments = Appointment.current(Date.current, current_user)
    @overdue_appointments = Appointment.overdue(current_user)
  end

  def mobile
  end

end

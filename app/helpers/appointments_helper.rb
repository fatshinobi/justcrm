module AppointmentsHelper
  def appointment_ico(appointment)
    class_name = 'glyphicon '
	class_name << 'glyphicon-envelope' if appointment.is_message?
	class_name << 'glyphicon-phone-alt' if appointment.is_call?
	class_name << 'glyphicon-comment' if appointment.is_meet?
	class_name << 'glyphicon-wrench' if appointment.is_task?
	class_name << ' icon-large float_pic'

	content_tag(:span, :class => class_name, "aria-hidden" => "true", :title => appointment.get_communication_type.to_s) {
	}
  end

  def set_appointment_status_paths(appointment, company, person, opportunity)
    if company
      set_statuses(Appointment, lambda {|u| appointment_set_status_from_company_path(id: appointment, status_name: u.value.to_s, company_parent_id: company.id)})
    elsif person
      set_statuses(Appointment, lambda {|u| appointment_set_status_from_person_path(id: appointment, status_name: u.value.to_s, person_parent_id: person)})
    elsif opportunity
      set_statuses(Appointment, lambda {|u| appointment_set_status_from_opportunity_path(id: appointment, status_name: u.value.to_s, opportunity_parent_id: opportunity)})
    else
      set_statuses(Appointment, lambda {|u| appointment_set_status_path(id: appointment, status_name: u.value.to_s)})
    end
  end
end

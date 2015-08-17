require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "conditionable caption for company" do
    company = companies(:goggle)
    caption = link_to(company.name, company, :class=>"index_show_button")
    assert_equal "<h2 class=\"active_caption\" title=\"Active\"><a class=\"index_show_button\" href=\"/companies/#{company.id}\">#{company.name}</a></h2>", conditionable_caption(company, caption)

    company.set_condition :stoped
    caption = link_to(company.name, company, :class=>"index_show_button")
    assert_equal "<h2 class=\"stoped_caption\" title=\"Stoped\"><a class=\"index_show_button\" href=\"/companies/#{company.id}\">#{company.name}</a></h2>", conditionable_caption(company, caption)

    company.set_condition :removed
    caption = link_to(company.name, company, :class=>"index_show_button")
    assert_equal "<h2 class=\"removed_caption\" title=\"Removed\"><a class=\"index_show_button\" href=\"/companies/#{company.id}\">#{company.name}</a></h2>", conditionable_caption(company, caption)
  end

  test "conditionable caption for person" do
    person = people(:one)
    caption = link_to(person.name, person, :class=>"index_show_button")
    assert_equal "<h2 class=\"active_caption\" title=\"Active\"><a class=\"index_show_button\" href=\"/people/#{person.id}\">#{person.name}</a></h2>", conditionable_caption(person, caption)

    person.set_condition :stoped
    caption = link_to(person.name, person, :class=>"index_show_button")
    assert_equal "<h2 class=\"stoped_caption\" title=\"Stoped\"><a class=\"index_show_button\" href=\"/people/#{person.id}\">#{person.name}</a></h2>", conditionable_caption(person, caption)

    person.set_condition :removed
    caption = link_to(person.name, person, :class=>"index_show_button")
    assert_equal "<h2 class=\"removed_caption\" title=\"Removed\"><a class=\"index_show_button\" href=\"/people/#{person.id}\">#{person.name}</a></h2>", conditionable_caption(person, caption)
  end

  test "statusable caption for appointment" do
    appointment = appointments(:one)

    path_string = edit_appointments_from_company_path(appointment, appointment.company)
    caption = link_to(appointment.when.to_formatted_s(:long), path_string, :class => "appointment_show_button", :title => appointment.get_communication_type.to_s)
    assert_equal "<p class=\"opened_caption\"><a class=\"appointment_show_button\" href=\"/appointments/#{appointment.id}/edit/companies/#{appointment.company.id}\" title=\"#{appointment.get_communication_type.to_s}\">#{appointment.when.to_formatted_s(:long)}</a></p>", statusable_caption(appointment, caption)

    appointment.set_status :done
    caption = link_to(appointment.when.to_formatted_s(:long), path_string, :class => "appointment_show_button", :title => appointment.get_communication_type.to_s)
    assert_equal "<p class=\"done_caption\"><a class=\"appointment_show_button\" href=\"/appointments/#{appointment.id}/edit/companies/#{appointment.company.id}\" title=\"#{appointment.get_communication_type.to_s}\">#{appointment.when.to_formatted_s(:long)}</a></p>", statusable_caption(appointment, caption)
  end

  test "statusable caption for opportinities" do
    opportunity = opportunities(:two)
    caption = link_to(opportunity.title, opportunity, :class=>"index_show_button")
    assert_equal "<h2 class=\"active_caption\" title=\"Open\"><a class=\"index_show_button\" href=\"/opportunities/#{opportunity.id}\">#{opportunity.title}</a></h2>", opportunity_statusable_caption(opportunity, caption)

    opportunity.set_status :finished
    caption = link_to(opportunity.title, opportunity, :class=>"index_show_button")
    assert_equal "<h2 class=\"removed_caption\" title=\"Finished\"><a class=\"index_show_button\" href=\"/opportunities/#{opportunity.id}\">#{opportunity.title}</a></h2>", opportunity_statusable_caption(opportunity, caption)

    opportunity.set_status :canceled
    caption = link_to(opportunity.title, opportunity, :class=>"index_show_button")
    assert_equal "<h2 class=\"stoped_caption\" title=\"Canceled\"><a class=\"index_show_button\" href=\"/opportunities/#{opportunity.id}\">#{opportunity.title}</a></h2>", opportunity_statusable_caption(opportunity, caption)
  end
	
end
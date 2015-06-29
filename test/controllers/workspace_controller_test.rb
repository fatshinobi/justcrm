require 'test_helper'
include Devise::TestHelpers

class WorkspacesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:mycrosoft)
    sign_in users(:one)
  end

  test "should get index" do
    5.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:one), when: DateTime.now)
    end

    5.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:one), when: DateTime.now - 1.day)
    end

    7.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:two), when: DateTime.now)
    end

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:appointments)
    assert_equal 5, assigns(:appointments).size

    assert_select '.appointments_entry', 5
  end

  test "get overdue appointments" do
    appointment = appointments(:one)
    appointment.company = companies(:mycrosoft)
    appointment.person = people(:one)
    appointment.save

    get :index
    assert_not_nil assigns(:overdue_appointments)
    assert_equal 2, assigns(:overdue_appointments).size
    assert_select '.short_appointments_entry', 2

    assigns(:overdue_appointments).each do |overdue_appointment|
      assert_select ".short_appointments_entry>h4>a[href=?]", edit_appointment_path(overdue_appointment)
      assert_select '.appointment_body_field', overdue_appointment.body
      if overdue_appointment.person then
        assert_select '.short_appointments_entry>p>a[title=?]', overdue_appointment.person.name do |anchors|
          assert_equal 1, anchors.count
          anchor = anchors[0]
          assert_equal person_path(overdue_appointment.person), anchor.attributes["href"]
        end
      end
      if overdue_appointment.company then
        assert_select '.short_appointments_entry>p>a[title=?]', overdue_appointment.company.name do |anchors|
          assert_equal 1, anchors.count
          anchor = anchors[0]
          assert_equal company_path(overdue_appointment.company), anchor.attributes["href"]
        end
      end
    end
  end
end

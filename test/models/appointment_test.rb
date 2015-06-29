require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  test "company cant be empty" do
    appointment = Appointment.new(body: 'test', user: users(:one))
    assert appointment.invalid?, 'Appointment cant be valid with empty company'
  end

  test "company and person must match" do
  	company = companies(:goggle)
  	person = people(:one)
	  appointment = Appointment.new(body: 'test', company: company, person: person, user: users(:one))

    assert appointment.invalid?, 'Person dont matches to company'	

  	company = companies(:mycrosoft)
  	person = people(:one)
	  appointment = Appointment.new(body: 'test', company: company, person: person, user: users(:one))

    assert appointment.valid?, 'Person matches to company'	
  end

  test "set type" do
    appointment = appointments(:one)
    assert_equal 0, appointment.communication_type
    assert_equal :message, appointment.get_communication_type
    assert appointment.is_message?, 'must be message'
    assert_not appointment.is_call?, 'cant be call'

    appointment.set_communication_type :call
    assert_equal 1, appointment.communication_type
    assert_equal :call, appointment.get_communication_type
    assert appointment.is_call?, 'must be call'
    assert_not appointment.is_message?, 'cant be message'

    appointment.set_communication_type :task
    assert_equal 2, appointment.communication_type
    assert_equal :task, appointment.get_communication_type
    assert appointment.is_task?, 'must be task'
    assert_not appointment.is_call?, 'cant be call'

    appointment.set_communication_type :meet
    assert_equal 3, appointment.communication_type
    assert_equal :meet, appointment.get_communication_type
    assert appointment.is_meet?, 'must be meet'
    assert_not appointment.is_message?, 'cant be message'
  end  

  test "reverse order task" do
    dt = DateTime.now
    Appointment.create(company: companies(:goggle), when: dt, user: users(:one))
    
    list = Appointment.all
    appointment = list.first
    assert appointment.when.to_i == dt.to_i, 'sorting is not valid'

    appointment = list.last
    assert appointment.when < dt, 'sorting 2 is not valid'
  end

  test "when is not nil by default" do
    appointment = Appointment.new(company: companies(:goggle), user: users(:one))
    assert appointment.when, 'when cant be nil'
  end

  test "set status" do
    appointment = appointments(:one)
    assert_equal 0, appointment.status
    assert_equal :open, appointment.get_status
    assert appointment.is_open?, 'must be opened'
    assert_not appointment.is_done?, 'cant be done'

    appointment.set_status :done
    assert_equal 1, appointment.status
    assert_equal :done, appointment.get_status
    assert appointment.is_done?, 'must be done'
    assert_not appointment.is_open?, 'cant be opened'
  end

  test "user cant be empty" do
    appointment = Appointment.new(body: 'Test', company: companies(:goggle))
    assert appointment.invalid?, 'User cant be empty'
  end

  test "by current date and curent user" do
    5.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:one), when: DateTime.now)
    end

    5.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:one), when: DateTime.now - 1.day)
    end

    7.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:two), when: DateTime.now)
    end

    3.times do |i|
      Appointment.create(company: companies(:goggle), user: users(:two), when: DateTime.now + 1.day)
    end

    appointments = Appointment.current(Date.current, users(:one))
    assert_equal 5, appointments.size

    appointments = Appointment.current(Date.current, users(:two))
    assert_equal 7, appointments.size
  end

  test "get overdue" do
    Appointment.create(company: companies(:goggle), user: users(:two), when: DateTime.now)
    3.times do
      Appointment.create(company: companies(:goggle), user: users(:two), when: DateTime.now - 1.day)
    end
    appointment = Appointment.new(company: companies(:goggle), user: users(:two), when: DateTime.now - 1.day)
    appointment.set_status :done
    appointment.save

    2.times do
      Appointment.create(company: companies(:goggle), user: users(:one), when: DateTime.now - 1.day)
    end

    appointments = Appointment.overdue(users(:two))
    #p appointments
    assert_equal 3, appointments.size
  end
end

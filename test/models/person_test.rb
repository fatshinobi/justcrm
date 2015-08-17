require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "person name must not be empty" do
    person = people(:one)
    person.name = nil
    assert person.invalid?
    assert person.errors[:name].any?
  end

  test "person name is not too small" do
    person = Person.new(name: "12", user: users(:one))
    assert person.invalid?
  end

  test "many companies mapping" do
    company_link = CompanyPerson.new(company: companies(:mycrosoft), role: 'Cleaner')
    company_link2 = CompanyPerson.new(company: companies(:goggle), role: 'Secretar')
		
    person = Person.new(name: 'Many Pakiyao', user: users(:one),
    company_people: [company_link, company_link2])

    assert person.save
    person.reload

    assert_equal 2, person.company_people.size
    assert_equal companies(:mycrosoft).name, person.company_people.first.company.name
    assert_equal companies(:goggle).name, person.company_people.second.company.name

    assert_equal 'Cleaner', person.company_people.first.role
    assert_equal 'Secretar', person.company_people.second.role

    assert_equal 3, Company.find_by_id(companies(:mycrosoft).id).company_people.size
    assert_equal 4, CompanyPerson.all.size
  end

  test "image loading must be valid" do
    person = Person.create!(name: 'Test with image', user: users(:one), ava: fixture_file_upload('/files/soldier.jpg', 'image/jpg'))
    assert(File.exists?(person.reload.ava.file.path))
  end

  test "right qty on pages" do
    15.times do |i|
      pers = Person.create(name: "test" + i.to_s, user: users(:one))
    end
    people = Person.page(1)
    assert_equal 10, people.size
    people = Person.page(2)
    assert_equal 7, people.size
  end

  test "add and update person tags" do
    tags = 'tag 1, tag 2, tag 3'
    person = Person.new(name: 'Test 1', user: users(:one))
    person.group_list.add(tags, parse: true)
    person.save
    person.reload
    assert_equal 3, person.group_list.count

    r_tags = person.group_list.to_s
    person.group_list.remove(r_tags, parse: true)

    tags = 'tag 1, tag 3'
    person = Person.new(name: 'Test 1', user: users(:one))
    person.group_list.add(tags, parse: true)
    person.save
    person.reload
    assert_equal 2, person.group_list.count
  end	

  test "get people by tag" do
    tags = 'tag 1, tag 2, tag 3'
    person = Person.new(name: 'Test 1', user: users(:one))
    person.group_list.add(tags, parse: true)
    person.save

    people = Person.tagged_with('tag 1', :on => :groups)
    assert_equal 1, people.count

    person = Person.new(name: 'Test 2', user: users(:one))
    person.group_list.add('tag 1')
    person.save
    people = Person.tagged_with('tag 1', :on => :groups)
    assert_equal 2, people.count
  end	

  test "should rescue with wrond tag" do
    tags = 'tag 1, tag 2, tag 3'
    person = Person.new(name: 'Test 1', user: users(:one))
    person.group_list.add(tags, parse: true)
    person.save

    people = Person.tagged_with("WrongTag", :on => :groups)
    assert_equal 0, people.count
  end

  test "person searching by name" do
    people = Person.contains('av')
    assert_equal 1, people.size
    people = Person.contains('a')
    assert_equal 2, people.size
  end

  test "set condition" do
    person = people(:one)
    assert_equal 0, person.condition
    assert_equal :active, person.get_condition

    person.set_condition :removed
    assert_equal 2, person.condition
    assert_equal :removed, person.get_condition

    person.set_condition :stoped
    assert_equal 1, person.condition
    assert_equal :stoped, person.get_condition

    person.set_condition :active
    assert_equal 0, person.condition
    assert_equal :active, person.get_condition

  end

  test "get active only" do
    people = Person.active
    assert_equal 2, people.size

    person = people(:one)
    person.set_condition :removed
    person.save

    people = Person.active
    assert_equal 1, people.size
  end

  test "get stoped only" do
    people = Person.stoped
    assert_equal 0, people.size

    person = people(:one)
    person.set_condition :stoped
    person.save

    people = Person.stoped
    assert_equal 1, people.size
  end

  test "get removed only" do
    people = Person.removed
    assert_equal 0, people.size

    person = people(:one)
    person.set_condition :removed
    person.save

    people = Person.removed
    assert_equal 1, people.size
  end

  test "get unremoved" do
    people = Person.unremoved
    assert_equal 2, people.size

    person = people(:one)
    person.set_condition :removed
    person.save

    people = Person.unremoved
    assert_equal 1, people.size

    person = people(:one)
    person.set_condition :stoped
    person.save

    people = Person.unremoved
    assert_equal 2, people.size
  end

  test "get unremoved person companies" do
    person = people(:one)
    company = companies(:goggle)
    company_link = CompanyPerson.new(company: company, role: 'test')

    person.company_people << company_link
    person.save
    person.reload
    assert_equal 2, person.company_people.unremoved.size

    company = person.company_people.unremoved.first.company
    company.set_condition :removed
    company.save

    person.reload
    assert_equal 1, person.company_people.unremoved.size
  end

  test "has many appointments" do
    company = companies(:goggle)
    person = Person.create(name: "John Underwood", user: users(:one))

    link = CompanyPerson.create(company: company, person: person)
    Appointment.create(company: company, person: person, body: 'test', user: users(:one))
    Appointment.create(company: company, person: person, body: 'test 2', user: users(:one))

    assert_equal 2, person.appointments.size
  end

  test "user cant be empty" do
    person = Person.new(name: 'Test')
    assert person.invalid?, 'User cant be empty'
  end

  test "desc sorted opportunities" do
    opportunity = opportunities(:two)
    opportunity.person = people(:one)
    opportunity.save

    dt = Date.current
    Opportunity.create(company: companies(:mycrosoft), person: people(:one), start: dt, user: users(:one), title: 'My very cool project')

    person = people(:one)
    opportunity = person.opportunities.first

    assert opportunity.start == dt, 'sorting is not valid'    	

    opportunity = person.opportunities.last
    assert opportunity.start < dt, 'sorting 2 is not valid'
  end

end


require 'test_helper'
include ActionDispatch::TestProcess

class CompanyTest < ActiveSupport::TestCase
	test "company name must not be empty" do
		company = companies(:mycrosoft)
		company.name = nil
		assert company.invalid?
		assert company.errors[:name].any?
	end

	test "company is not valid without a unique name" do
		company = Company.new(name: companies(:mycrosoft).name)
		assert company.invalid?
		assert_equal ["has already been taken"], company.errors[:name]
	end

	test "company name is not too small" do
		company = Company.new(name: "12")
		assert company.invalid?
		assert company.errors[:name].any?
	end

	test "many people mapping" do
		person_link = CompanyPerson.new(person: people(:one), role: 'Cleaner')
		person_link2 = CompanyPerson.new(person: people(:two), role: 'Secretar')
		
		company = Company.new(name: 'Many People Test', user: users(:one),
			company_people: [person_link, person_link2])

		assert company.save
		company.reload

		assert_equal 2, company.company_people.size
		assert_equal people(:one).name, company.company_people.first.person.name
		assert_equal people(:two).name, company.company_people.second.person.name

		assert_equal 'Cleaner', company.company_people.first.role
		assert_equal 'Secretar', company.company_people.second.role

		assert_equal 2, Person.find_by_id(people(:one).id).company_people.size
		assert_equal 4, CompanyPerson.all.size
	end

	test "image loading must be valid" do
		company = Company.create!(name: 'Test with image', user: users(:one), ava: fixture_file_upload('/files/soldier.jpg', 'image/jpg'))
    	assert(File.exists?(company.reload.ava.file.path))
	end

	test "right qty on pages" do
		15.times do |i|
			comp = Company.create(name: "test" + i.to_s, user: users(:one))
		end
		companies = Company.page(1)
		assert_equal 10, companies.size
		companies = Company.page(2)
		assert_equal 7, companies.size
	end

	test "add and update company tags" do
		tags = 'tag 1, tag 2, tag 3'
		company = Company.new(name: 'Test 1', user: users(:one))
		company.group_list.add(tags, parse: true)
		company.save
		company.reload
		assert_equal 3, company.group_list.count
		
		r_tags = company.group_list.to_s
		company.group_list.remove(r_tags, parse: true)

		tags = 'tag 1, tag 3'
		company.group_list.add(tags, parse: true)
		company.save
		company.reload
		assert_equal 2, company.group_list.count
	end

	test "get companies by tag" do
		tags = 'tag 1, tag 2, tag 3'
		company = Company.new(name: 'Test 1', user: users(:one))
		company.group_list.add(tags, parse: true)
		company.save

		companies = Company.tagged_with('tag 1', :on => :groups)
		assert_equal 1, companies.count
		
		company = Company.new(name: 'Test 2', user: users(:one))
		company.group_list.add('tag 1')
		company.save
		companies = Company.tagged_with('tag 1', :on => :groups)
		assert_equal 2, companies.count
	end

	test "should rescue with wrond tag" do
		tags = 'tag 1, tag 2, tag 3'
		company = Company.new(name: 'Test 1', user: users(:one))
		company.group_list.add(tags, parse: true)
		company.save

		companies = Company.tagged_with("WrongTag", :on => :groups)
		assert_equal 0, companies.count
	end

	test "company searching by name" do
		companies = Company.contains('gg')
		assert_equal 1, companies.size
		companies = Company.contains('o')
		assert_equal 2, companies.size
	end

	test "set condition" do
		company = companies(:goggle)
		assert_equal 0, company.condition
		assert_equal :active, company.get_condition

		company.set_condition :removed
		assert_equal 2, company.condition
		assert_equal :removed, company.get_condition

		company.set_condition :stoped
		assert_equal 1, company.condition
		assert_equal :stoped, company.get_condition

		company.set_condition :active
		assert_equal 0, company.condition
		assert_equal :active, company.get_condition
	end

	test "get active only" do
		companies = Company.active
		assert_equal 2, companies.size

		company = companies(:mycrosoft)
		company.set_condition :removed
		company.save

		companies = Company.active
		assert_equal 1, companies.size
	end

	test "get stoped only" do
		companies = Company.stoped
		assert_equal 0, companies.size

		company = companies(:mycrosoft)
		company.set_condition :stoped
		company.save

		companies = Company.stoped
		assert_equal 1, companies.size
	end

	test "get removed only" do
		companies = Company.removed
		assert_equal 0, companies.size

		company = companies(:mycrosoft)
		company.set_condition :removed
		company.save

		companies = Company.removed
		assert_equal 1, companies.size
	end

	test "get unremoved" do
		companies = Company.unremoved
		assert_equal 2, companies.size

		company = companies(:mycrosoft)
		company.set_condition :removed
		company.save

		companies = Company.unremoved
		assert_equal 1, companies.size

		company = companies(:goggle)
		company.set_condition :stoped
		company.save

		companies = Company.unremoved
		assert_equal 1, companies.size

	end

	test "get unremoved company people" do
		company = companies(:mycrosoft)
		assert_equal 2, company.company_people.size

		person = company.company_people.first.person
		person.set_condition :removed
		person.save

		company.reload
		assert_equal 1, company.company_people.size		
	end

    test "has many appointments" do
    	company = companies(:goggle)
    	assert_equal 2, company.appointments.size
    end

    test "desc sorted appointments" do
   	    dt = DateTime.now
	    Appointment.create(company: companies(:goggle), when: dt, user: users(:one))

    	company = companies(:goggle)
    	appointment = company.appointments.first
    	assert appointment.when.to_i == dt.to_i, 'sorting is not valid'    	

	    appointment = company.appointments.last
	    assert appointment.when < dt, 'sorting 2 is not valid'
    end

    test "user cant be empty" do
    	company = Company.new(name: 'Test')
    	assert company.invalid?, 'User cant be empty'
    end

    test "desc sorted opportunities" do
		dt = Date.current
	    Opportunity.create(company: companies(:goggle), start: dt, user: users(:one), title: 'My very cool project')

    	company = companies(:goggle)
    	opportunity = company.opportunities.first
    	assert opportunity.start == dt, 'sorting is not valid'    	

	    opportunity = company.opportunities.last
	    assert opportunity.start < dt, 'sorting 2 is not valid'

    end

end

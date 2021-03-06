require 'test_helper'
include Devise::TestHelpers

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = people(:one)
    sign_in users(:one)    
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
    assert_equal 2, assigns(:people).size
    assert_template :index
    assert_select '.entry', 2
    assert_select "a[class='index_show_button']", 2
    assert_select '.ava_pic', 2   

    assigns(:people).each do |person|
      assert_select 'h2', person.name
      assert_select '.about_text', person.about
      assert_select "a[class='index_show_button']", person.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal person_path(person), anchor.attributes["href"].value
      end
      assert_select "a[title=?]", person.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal person_path(person), anchor.attributes["href"].value
      end
    end

  end

  test "index person count" do
    get :index
    assert_equal(assigns(:people).count, 2)    
  end

  test "new person button on index" do
    get :index
    assert_select "a", 'New Person' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal new_person_path, anchor.attributes["href"].value
    end
  end

  test "index default logo instead of empty" do
    new_person = Person.create(name: 'Test 1', ava: nil, user: users(:one))
    get :index
    assert_response :success
    assert_template :index
    assert_equal 3, assigns(:people).size
    assigns(:people).each do |person|
      if person.id == new_person.id then
        assert_select 'img.ava_pic[src=?]', '/assets/thumb_anonymous.png'        
      else
        assert_select 'img.ava_pic[src=?]', person.ava.thumb.url
      end
    end
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
    assert_select 'h1', 'New person'    
    assert_select 'form' do
      assert_select '.form_field' do
        assert_select '.control-label', 'Avatar'
      end

      assert_select '.ava_loader'
      assert_select '.form_field', 'Name'
      assert_select '.form_field', 'About'
      assert_select '.form_field', 'Phone'
      assert_select '.form_field', 'Web'
      assert_select '.form_field', 'Twitter'
      assert_select '.form_field', 'Facebook'
      assert_select '.form_field', 'Email'      
      assert_select '.control-label', 'Curator'      
      assert_select '.form_field', 'List All Tags, separate each tag by a comma'
      assert_select ".form_accept_button" do
        assert_select "[value=?]", 'Save'
      end
    end

    assert_select "a", 'Back' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal people_path, anchor.attributes["href"].value
    end
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, user_id: users(:one).id }
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test "can't create person whith empty name" do
    assert_no_difference('Person.count') do
      post :create, person: { about: @person.about, name: "", phone: @person.phone, web: @person.web, facebook: @person.facebook, twitter: @person.twitter }
    end
    assert_select 'form' do
      assert_select '.has-error' do 
        assert_select '.control-label', 'Name'
      end
    end    
    assert_select "li", 'Name can\'t be blank'
  end

  test "can't create person whith too short name" do
    assert_no_difference('Person.count') do
      post :create, person: { about: @person.about, name: "12", phone: @person.phone, web: @person.web, facebook: @person.facebook, twitter: @person.twitter }
    end
    assert_select 'form' do
      assert_select '.has-error' do 
        assert_select '.control-label', 'Name'
      end
    end    
    assert_select 'li', 'Name is too short (minimum is 3 characters)'
  end

  test "should show person" do
    @person.group_list.add 'tag 1, tag 2', parse: true
    @person.save

    get :show, id: @person
    assert_response :success
    assert_template :show

    assert_equal @person.name, assigns(:person).name
    assert_equal @person.phone, assigns(:person).phone
    assert_equal @person.web, assigns(:person).web
    assert_equal @person.facebook, assigns(:person).facebook
    assert_equal @person.twitter, assigns(:person).twitter

    assert_select 'h1', assigns(:person).name
    assert_select '.show_field', "Phone:\n" + assigns(:person).phone
    assert_select '.show_field', "Web:\n" + assigns(:person).web    
    assert_select '.show_field', "About:\n" + assigns(:person).about
    assert_select '.show_field', "Facebook:\n" + assigns(:person).facebook
    assert_select '.show_field', "Twitter:\n" + assigns(:person).twitter
    assert_select '.show_field', "Curator:\n" + assigns(:person).user.name
    assert_select '.show_field', "Email:\n" + assigns(:person).email

    assert_select '.ava_big_pic'

    assert_select "a", 'Edit' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal edit_person_path(@person), anchor.attributes["href"].value
    end
    assert_select "a", 'Back' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal people_path, anchor.attributes["href"].value
    end
    assert_select 'p#show_tags_field' do
      @person.tags.each do |tag|
        assert_select 'a[href=?]', person_tag_path(tag.name)
      end
    end
  end

  test "show default logo instead of empty" do
    person = Person.create(name: 'Test 1', user: users(:one))
    get :show, id: person
    assert_response :success
    assert_template :show

    assert_select 'img.ava_big_pic[src=?]', '/assets/anonymous.png'

    get :show, id: @person
    assert_response :success
    assert_template :show

    assert_select 'img.ava_big_pic[src=?]', @person.ava.normal.url
  end


  test "show companies of person" do
    company_link = CompanyPerson.new(company: companies(:goggle), role: 'Cleaner')    
    @person.company_people << company_link
    get :show, id: @person
    assert_response :success
    assert_template :show
    assert_equal 2, assigns(:person).company_people.size
    assert_select 'h2', 'Companies:'
    assert_select '.person_company_entry', 2
    assert_select '.company_ava_pic', 2
    @person.company_people.each do |company_person|
      assert_select 'h3', company_person.company.name
      assert_select 'p', company_person.role      
      assert_select "a", company_person.company.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal company_path(company_person.company), anchor.attributes["href"].value
      end
      assert_select 'a[title=?]', company_person.company.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal company_path(company_person.company), anchor.attributes["href"].value
      end      
    end    
  end

  test "show companies of person default logo instead of empty" do
    new_company = Company.create(name: "Test 1", user: users(:one), ava: nil)
    company_link = CompanyPerson.new(company: new_company, role: 'test')
    new_person = Person.create(name: 'Test 1', company_people: [company_link], user: users(:one))
    get :show, id: new_person
    assert_response :success
    assert_template :show

    assert_select 'img.company_ava_pic[src=?]', '/assets/thumb_anonym_company.png'    

    company_link = CompanyPerson.new(company: companies(:mycrosoft), role: 'test')
    new_person = Person.create(name: 'Test 2', company_people: [company_link], user: users(:one))

    get :show, id: new_person
    assert_response :success
    assert_template :show

    assert_select 'img.company_ava_pic[src=?]', company_link.company.ava.thumb.url

  end

  test "should get edit" do
    @person.facebook = "facebook_text"
    @person.twitter = "twitter_text"
    @person.group_list.add 'tag 1, tag 2', parse: true

    @person.save
    get :edit, id: @person
    assert_response :success
    assert_template :edit
    assert_equal 1, assigns(:person).company_people.size    
    assert_select '.fields', 1
    @person.company_people.each do |company_link|
      assert_select 'input.role_field[value=?]', company_link.role
      #assert_select 'select.form-control' do
      #  assert_select 'option[selected="selected"]', :text => company_link.company.name
      #end
    end    
    assert_select 'form' do
      assert_select '.form_field' do
        assert_select '.control-label', 'Avatar'
      end

      assert_select '.ava_loader'
      assert_select 'input#person_name[value=?]', @person.name
      assert_select 'textarea#person_about', @person.about
      assert_select 'input#person_phone[value=?]', @person.phone
      assert_select 'input#person_web[value=?]', @person.web
      assert_select 'input#person_twitter[value=?]', @person.twitter
      assert_select 'input#person_facebook[value=?]', @person.facebook
      assert_select 'input#person_tags[value=?]', @person.group_list.to_s
      assert_select 'select#person_user_id' do
        assert_select 'option[selected="selected"]', :text => @person.user.name
      end

    end
  end

  test "should update person" do
    patch :update, id: @person, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web }
    assert_redirected_to person_path(assigns(:person))
    assert_equal 'David', Person.find(@person.id).name
  end

  test "get show with appointments" do
    company = companies(:goggle)
    person = Person.create(name: "John Underwood", user: users(:one))
    link = CompanyPerson.create(company: company, person: person)
    Appointment.create(company: company, person: person, body: 'test', user: users(:one))
    Appointment.create(company: company, person: person, body: 'test 2', when: DateTime.new(2014, 1, 1, 1, 1, 1), user: users(:one))

    get :show, id: person
    assert_response :success
    assert_template :show

    appointments = assigns(:person).appointments
    assert_equal 2, appointments.size

    assert_select 'h2', 'Appointments:'
    assert_select '.appointments_entry', 2

    appointments.each do |appointment|
      assert_select 'a', appointment.when.to_formatted_s(:long)
      assert_select '.appointment_body_field', appointment.body

      assert_select "a[class='appointment_show_button']", appointment.when.to_formatted_s(:long) do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal edit_appointments_from_person_path(appointment, assigns(:person)), anchor.attributes["href"].value
      end

      if appointment.company then
        assert_select '.appointments_entry>a[title=?]', appointment.company.name do |anchors|
          anchor = anchors[0]
          assert_equal company_path(appointment.company), anchor.attributes["href"].value
        end
      end
    end
  end

  test "user by default must be current" do
    get :new
    assert_response :success
    assert_template :new
    assert_select 'form' do
      assert_select 'select#person_user_id' do
        assert_select 'option[selected="selected"]', :text => users(:one).name
      end
    end
    assert_equal assigns(:person).user.id, users(:one).id    
    sign_out users(:one)

    sign_in users(:two)
    get :new
    assert_response :success
    assert_template :new
    assert_select 'form' do
      assert_select 'select#person_user_id' do
        assert_select 'option[selected="selected"]', :text => users(:two).name
      end
    end
    assert_equal assigns(:person).user.id, users(:two).id
  end

  test "get show with opportunities" do
    person = people(:one)

    opportunity = opportunities(:one)
    opportunity.company = companies(:mycrosoft)
    opportunity.person = person
    opportunity.save

    opportunity = opportunities(:two)
    opportunity.person = person
    opportunity.save

    get :show, id: person
    assert_response :success
    assert_template :show

    opportunities = assigns(:person).opportunities

    assert_equal 2, opportunities.size

    assert_select 'h2', 'Opportunities:'
    assert_select '#opportunity_entries>.entry', 2

    opportunities.each do |opportunity|
      assert_select 'h2', opportunity.title
      assert_select '.about_text', opportunity.description
      assert_select "a[class='index_show_button']", opportunity.title do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal opportunity_path(opportunity), anchor.attributes["href"].value
      end
    end
  end  

  test "should update person whith chosen company" do
    @person.company_people.delete_all
    patch :update, id: @person, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, :company_people_attributes=>{'0'=>{id: '', role: 'Manager', company_id: companies(:mycrosoft), new_company_name: 'New Company Name', _destroy: 'false'}}}
    assert_redirected_to person_path(assigns(:person))
    assert_equal 'David', Person.find(@person.id).name
    result_person = assigns(:person)
    assert_equal 1, result_person.company_people.size
    assert_equal companies(:mycrosoft), result_person.company_people.first.company
  end

  test "should update person whith new company" do
    @person.company_people.delete_all
    patch :update, id: @person, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, :company_people_attributes=>{'0'=>{id: '', role: 'Manager', company_id: '', new_company_name: 'New Company Name', _destroy: 'false'}}}
    assert_redirected_to person_path(assigns(:person))
    assert_equal 'David', Person.find(@person.id).name
    result_person = assigns(:person)
    assert_equal 1, result_person.company_people.size
    assert_equal 'New Company Name', result_person.company_people.first.company.name
  end

  test "should create person whith chosen company" do
    assert_difference('Person.count') do
      post :create, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, user_id: users(:one).id, :company_people_attributes=>{'0'=>{id: '', role: 'Manager', company_id: companies(:mycrosoft), new_company_name: 'New Company Name', _destroy: 'false'}}}
    end

    assert_redirected_to person_path(assigns(:person))
    result_person = assigns(:person)
    assert_equal 'David', result_person.name
    assert_equal 1, result_person.company_people.size
    assert_equal companies(:mycrosoft), result_person.company_people.first.company
  end

  test "should create person whith new company" do
    assert_difference('Person.count') do
      post :create, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, user_id: users(:one).id, :company_people_attributes=>{'0'=>{id: '', role: 'Manager', company_id: '', new_company_name: 'New Company Name', _destroy: 'false'}}}
    end

    assert_redirected_to person_path(assigns(:person))
    result_person = assigns(:person)
    assert_equal 'David', result_person.name
    assert_equal 1, result_person.company_people.size
    assert_equal 'New Company Name', result_person.company_people.first.company.name
  end

  test "should update person whithout company id and name" do
    @person.company_people.delete_all
    patch :update, id: @person, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, :company_people_attributes=>{'0'=>{id: '', role: 'Manager', company_id: '', new_company_name: '', _destroy: 'false'}}}
    assert_redirected_to person_path(assigns(:person))
    assert_equal 'David', Person.find(@person.id).name
    result_person = assigns(:person)
    assert_equal 0, result_person.company_people.size
  end

  test "should create person whithout company id and name" do
    assert_difference('Person.count') do
      post :create, person: { about: @person.about, facebook: @person.facebook, name: @person.name, phone: @person.phone, twitter: @person.twitter, web: @person.web, user_id: users(:one).id, :company_people_attributes=>{'0'=>{id: '', role: 'Manager', company_id: '', new_company_name: '', _destroy: 'false'}}}
    end

    assert_redirected_to person_path(assigns(:person))
    result_person = assigns(:person)
    assert_equal 'David', result_person.name
    assert_equal 0, result_person.company_people.size
  end

  test "shoud live search" do
    get :live_search, q: "v"
    assert_equal 1, assigns(:people).size

    get :live_search, q: "a"
    assert_equal 2, assigns(:people).size

    assert_select '.choice_entry' do
      assert_template 'live_search'
      assert_select 'a.live-choice', 2
      assert_select 'a.live-choice', people(:one).name
      assert_select 'a.live-choice', people(:two).name

      assert_select 'a.live-choice[id=?]', "live-choice-#{people(:one).id.to_s}"
      assert_select 'a.live-choice[id=?]', "live-choice-#{people(:two).id.to_s}"

      assert_select 'img.ava_pic', 2      
    end
  end

  test "shoud live search with parent" do
    person = Person.create(name: "John Adam", user: users(:one))
    link = CompanyPerson.create(company: companies(:goggle), person: person)

    person = Person.create(name: "John Underwood", user: users(:one))
    link = CompanyPerson.create(company: companies(:mycrosoft), person: person)

    get :live_search, q: "a", p: companies(:mycrosoft).id
    assert_equal 2, assigns(:people).size

    get :live_search, q: "a", p: ""
    assert_equal 3, assigns(:people).size
      
  end
  
  test "should get right json api index" do
    get :index, format: :json

    json = JSON.parse(response.body)

    assert_equal 2, json.length
    assert_equal 1, json.select {|person| person['name'].include?('Adam')}.length, 'Adam must be in json'
    assert_equal 1, json.select {|person| person['name'].include?('David')}.length, 'David must be in json'

    result = json.select {|person| person['id'] == @person.id}[0]

    assert_equal @person.name, result['name'], 'Person name must be in json'
    assert_equal @person.about, result['about'], 'Person about must be in json'
    assert_equal @person.phone, result['phone'], 'Person phone must be in json'
    assert_equal @person.email, result['email'], 'Person email must be in json'
    assert_equal @person.facebook, result['facebook'], 'Person facebook must be in json'
    assert_equal @person.twitter, result['twitter'], 'Person twitter must be in json'
    assert_equal @person.condition, result['condition'], 'Person condition must be in json'
    assert_equal @person.group_list, result['group_list'], 'Person tags must be in json'
  end

  test "should get right json api show" do
    @person.group_list = ['tag1', 'tag2']
    @person.save()

    appointment = appointments(:one)
    appointment.company = companies(:mycrosoft)
    appointment.person = @person
    appointment.save()

    opportunity = opportunities(:two)
    opportunity.person = @person
    opportunity.save()

    get :show, format: :json, id: @person

    json = JSON.parse(response.body)

    assert_equal @person.name, json['name']
    assert_equal @person.about, json['about']
    assert_equal @person.phone, json['phone']
    assert_equal @person.email, json['email']
    assert_equal @person.facebook, json['facebook']
    assert_equal @person.twitter, json['twitter']
    assert_equal @person.web, json['web']
    assert_equal @person.condition, json['condition']
    assert_equal @person.group_list.join(', '), json['group_list']

    links = json['companies']
    assert_equal 1, links.size
    assert_equal companies(:mycrosoft).id, links[0]['company']['id']
    assert_equal 'Owner', links[0]['role']

    apps = json['appointments']
    assert_equal 1, apps.size
    assert_equal users(:one).id, apps[0]['user']['id']
    assert_equal companies(:mycrosoft).id, apps[0]['company']['id']
    assert_equal appointment.when.strftime('%m/%d/%Y %H:%M:%S'), apps[0]['when']
    assert_equal appointment.status, apps[0]['status']
    assert_equal appointment.body, apps[0]['body']

    opps = json['opportunities']
    assert_equal 1, opps.size
    assert_equal opportunity.title, opps[0]['title']
    assert_equal opportunity.description, opps[0]['description']
    assert_equal opportunity.start.strftime('%m/%d/%Y'), opps[0]['start']
    assert_equal opportunity.finish.strftime('%m/%d/%Y'), opps[0]['finish']    
    assert_equal opportunity.stage, opps[0]['stage']
    assert_equal opportunity.status, opps[0]['status']
    assert_equal opportunity.amount, opps[0]['amount']    
    assert_equal companies(:mycrosoft).id, opps[0]['company']['id']
    assert_equal opportunity.user.id, opps[0]['user']['id']
  end

  test "should get index json without pagination" do
    15.times do |i|
      pers = Person.create(name: "test" + i.to_s, user: users(:one))
    end
    get :index, format: :json

    json = JSON.parse(response.body)

    assert_equal 17, json.length
  end

end

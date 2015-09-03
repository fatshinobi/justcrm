class PeopleController < ApplicationController
  include ConditionableController  
  before_action :set_person, only: [:show, :edit, :update, :destroy, :activate, :stop]
  before_action :list_initialize, only: [:index]

  respond_to :html
  
  def index
    case 
    when params[:tag]
      @people = Person.unremoved.tagged_with(params[:tag], :on => :groups).order(:created_at).page(params[:page])      
    when params[:contains]
      @people = Person.unremoved.contains(params[:contains]).order(:created_at).page(params[:page])  
    when params[:removed]
      @people = Person.removed.order(:created_at).page(params[:page])  
    else
      @people = Person.unremoved.order(:created_at).page(params[:page])
    end

    @tags = Person.group_counts    
    respond_with(@people)
  end

  def show
    @parent_person = @person
    @companies = @person.company_people_unremoved
    respond_with(@person)
  end

  def new
    @person = Person.new(user: current_user)
    respond_with(@person)
  end

  def edit
  end

  def create
    @person = Person.new(person_params)
    @person = set_new_company_if_id_is_nill(@person)
    @person.save
    respond_with(@person)
  end

  def update
    @person.assign_attributes(person_params)
    @person = set_new_company_if_id_is_nill(@person)
    @person.save
    respond_with(@person)
  end

  def live_search
    if params[:q] != ''
      if (params[:p].present?)
        company = Company.find(params[:p])
        @people = company.people.unremoved.contains(params[:q]).order(:created_at)
      else
        @people = Person.unremoved.contains(params[:q]).order(:created_at) 
      end
    else
      @people = []
    end
    render :layout => false
  end

  private
    def set_new_company_if_id_is_nill(person)
      person.company_people.each do |link|
        if !link.company then
          if link.new_company_name.blank?
            person.company_people.delete(link)
          else
            company = Company.create(name: link.new_company_name, user: current_user);
            link.company = company
          end
        end
      end
      person
    end

    def set_person
      @person = Person.find(params[:id])
      conditionable_init @person, people_path      
    end

    def person_params
      params.require(:person).permit(:name, :about, :phone, :facebook, :twitter, :web, :ava, :group_list, :user_id, :company_people_attributes => [:id, :role, :company_id, :new_company_name, :_destroy])
    end

    def list_initialize
      @is_list = true
    end
end

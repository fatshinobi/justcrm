class PeopleController < ApplicationController
  include ConditionableController  
  before_action :set_person, only: [:show, :edit, :update, :destroy, :activate, :stop]
  before_action :list_initialize, only: [:index]

  respond_to :html
  
  def index
    if !params[:tag] and !params[:contains] and !params[:removed] then
      @people = Person.unremoved.order(:created_at).page(params[:page])    
    end
    @people = Person.unremoved.tagged_with(params[:tag], :on => :groups).order(:created_at).page(params[:page]) if params[:tag]
    @people = Person.unremoved.contains(params[:contains]).order(:created_at).page(params[:page]) if params[:contains]
    @people = Person.removed.order(:created_at).page(params[:page]) if params[:removed]

    @tags = Person.group_counts    
    respond_with(@people)
  end

  def show
    @parent_person = @person
    @companies = @person.company_people
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
    @person.save
    respond_with(@person)
  end

  def update
    #byebug
    #@person.update(person_params)
    
    @person.assign_attributes(person_params)
    @person.company_people.each do |link|
      if !link.company then
        company = Company.create(name: link.new_company_name, user: current_user);
        link.company = company
      end
    end
    @person.save
    respond_with(@person)
  end

  def live_search
    if params[:q] != ''
      @people = Person.unremoved.contains(params[:q]).order(:created_at) 
    else
      @people = []
    end
    render :layout => false
  end

  private
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

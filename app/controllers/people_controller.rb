class PeopleController < ApplicationController
  include ConditionableController  
  before_action :set_person, only: [:show, :edit, :update, :destroy, :activate, :stop]
  before_action :list_initialize, only: [:index]
  before_action :set_people, only: [:index], if: -> { request.format.html? }
  before_action :set_people_without_pages, only: [:index], if: -> { request.format.json? }

  respond_to :html, :json
  
  def index
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
        @people = company.people.contains(params[:q])
      else
        @people = Person.unremoved.contains(params[:q])
      end
    else
      @people = []
    end
    render :layout => false
  end

  def tags
    respond_to do |format|
      format.json{ @tags = Person.group_counts }
    end
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
      params.require(:person).permit(:name, :about, :phone, :facebook, :twitter, :web, :ava, :group_list, :email, :user_id, :company_people_attributes => [:id, :role, :company_id, :new_company_name, :_destroy])
    end

    def list_initialize
      @is_list = true
    end

    def set_people
      case 
      when params[:tag]
        selection = Person.unremoved.tagged_with(params[:tag], :on => :groups)
      when params[:contains]
        selection = Person.unremoved.contains(params[:contains])
      when params[:removed]
        selection = Person.removed
      else
        selection = Person.unremoved
      end

      @people = selection.page(params[:page])
      @tags = Person.group_counts
    end

    def set_people_without_pages
      @people = Person.unremoved
    end
end

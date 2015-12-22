class CompaniesController < ApplicationController
  include ConditionableController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :activate, :stop]
  before_action :list_initialize, only: [:index]
  before_action :set_companies, only: [:index], if: -> { request.format.html? }
  before_action :set_companies_without_pages, only: [:index], if: -> { request.format.json? }

  respond_to :html, :json
    
  def index
    respond_with(@companies)
  end

  def show
    @parent_company = @company
    @people = @company.company_people_unremoved
    respond_with(@company)
  end

  def new
    @company = Company.new(user: current_user)
    respond_with(@company)
  end

  def edit
  end

  def create
    @company = Company.new(company_params)
    @company.save
    respond_with(@company)
  end

  def update
    @company.update(company_params)
    respond_with(@company)
  end

  def live_search
    if params[:q] != ''
      @companies = Company.unremoved.contains(params[:q])
    else
      @companies = []
    end
    render :layout => false
  end

  def tags
    respond_to do |format|
      format.json{ @tags = Company.group_counts }
    end
  end

  private
    def list_initialize
      @is_list = true
    end

    def set_company
      @company = Company.find(params[:id])
      conditionable_init @company, companies_path
    end

    def company_params
      params.require(:company).permit(:name, :about, :phone, :web, :ava, :group_list, :user_id)
    end

    def set_companies
      case
      when params[:tag]
        selection = Company.unremoved.tagged_with(params[:tag], :on => :groups)
      when params[:contains]
        selection = Company.unremoved.contains(params[:contains])
      when params[:removed]
        selection = Company.removed
      else
        selection = Company.unremoved
      end
      
      @companies = selection.page(params[:page])
      @tags = Company.group_counts
    end

    def set_companies_without_pages
      @companies = Company.unremoved
    end
end

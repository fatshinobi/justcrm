class CompaniesController < ApplicationController
  include ConditionableController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :activate, :stop]
  before_action :list_initialize, only: [:index]

  respond_to :html
    
  def index
    case
    when params[:tag]
      @companies = Company.unremoved.tagged_with(params[:tag], :on => :groups).order(:created_at).page(params[:page])      
    when params[:contains]
      @companies = Company.unremoved.contains(params[:contains]).order(:created_at).page(params[:page])  
    when params[:removed]      
      @companies = Company.removed.order(:created_at).page(params[:page])
    else
      @companies = Company.unremoved.order(:created_at).page(params[:page])      
    end

    @tags = Company.group_counts
    respond_with(@companies)
  end

  def show
    @parent_company = @company
    @people = @company.company_people
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
    #byebug
    @company.update(company_params)
    respond_with(@company)
  end

  def live_search
    if params[:q] != ''
      @companies = Company.unremoved.contains(params[:q]).order(:created_at) 
    else
      @companies = []
    end
    render :layout => false
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
end

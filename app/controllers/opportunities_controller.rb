class OpportunitiesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :js_request?

  before_action :set_opportunity, only: [:show, :edit, :update, :destroy, :next_stage, :prev_stage, :set_status]
  before_action :init_status, only: [:set_status]
  before_action :list_initialize, only: [:index]  
  respond_to :html
  
  def index
    respond_to do |format|
      format.html do
        @opportunities = Opportunity.by_user current_user
        respond_with(@opportunities)
      end
      format.js do
        set_opportunities_by_stage
        render :index
      end
    end
  end

  def show
    @parent_opportunity = @opportunity
    respond_with(@opportunity)
  end

  def new
    @opportunity = Opportunity.new
    respond_with(@opportunity)
  end

  def edit
  end

  def create
    @opportunity = Opportunity.new(opportunity_params)
    @opportunity.save
    respond_with(@opportunity)
  end

  def update
    @opportunity.update(opportunity_params)
    respond_with(@opportunity)
  end

  def destroy
  end

  def prev_stage
    @opportunity.prev_stage
    @opportunity.save
    redirect_to opportunity_path(@opportunity)
  end

  def next_stage
    @opportunity.next_stage
    @opportunity.save
    redirect_to opportunity_path(@opportunity)
  end

  def funnel_data
    awareness_qty = qty_by_stage :awareness
    interest_qty = qty_by_stage :interest
    decision_qty = qty_by_stage :decision
    bue_qty = qty_by_stage :buy

    data = []
    data << {:label => "awareness", :data => awareness_qty}
    data << {:label => "interest", :data => interest_qty}
    data << {:label => "decision", :data => decision_qty}
    data << {:label => "buy", :data => bue_qty}

    respond_to do |format|
      format.json {render json: data}
    end
  end

  protected
    def js_request?
      request.format.js?
    end

  private
    def list_initialize
      @is_list = true
    end

    def set_opportunities_by_stage
        @stage = params[:stage]
        @opportunities = @stage ? Opportunity.by_stage(@stage.to_sym, current_user) : Opportunity.by_user(current_user)
    end

    def qty_by_stage(stage)
      opportunities = Opportunity.by_stage stage, current_user
      opportunities.size
    end

    def set_opportunity
      @opportunity = Opportunity.find(params[:id])
    end

    def init_status
      @status_name = params[:status_name]
    end

    def opportunity_params
      params.require(:opportunity).permit(:title, :start, :finish, :description, :stage, :status, :company_id, :person_id, :user_id, :amount)
    end
end

class UsersController < ApplicationController
  include ConditionableController	
  before_action :check_permissions
  before_action :set_user, only: [:edit, :update, :destroy, :activate, :stop]
  before_action :block_user, only: [:destroy, :stop]
  before_action :unblock_user, only: [:activate]	
  respond_to :html

  def index
    @users = User.all.order(:created_at)		
    respond_with(@users)
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to users_path
  end

  def check_permissions
    authorize! :create, current_user
  end

  private

  def block_user
    @user.add_role :blocked
  end

  def unblock_user
    @user.remove_role :blocked
  end

  def set_user
    @user = User.find(params[:id])
    conditionable_init @user, users_path		
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end

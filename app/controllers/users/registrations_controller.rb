class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_permissions, :only=>[:new, :create, :cancel]
  before_action :configure_permitted_parameters, if: :devise_controller?

  skip_before_action :require_no_authentication

  def new
    super
  end

  def update
    super
  end

  def check_permissions
    if !current_user
      redirect_to new_user_session_path
    else
      authorize! :create, User
    end
  end

  def sign_up(resource_name, resource)
  end

  def after_sign_up_path_for(resource)
    users_path
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {
      |u| u.permit(:email, :password, :password_confirmation, :name)
    }
  end

end
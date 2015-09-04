class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'edit', only: [:edit, :new]  

  before_action :authenticate_user!

  #fix cancan bug
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  load_and_authorize_resource unless: [:devise_controller?]

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    render '/shared/access_denied'
  end

end

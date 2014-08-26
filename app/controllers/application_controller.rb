class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::RoutingError, :with => :render_404

  def after_sign_in_path_for(resource) 
   index_path
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end
  

  def  render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  protected
  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :photo) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :is_female, :date_of_birth, :photo) }
  end
end

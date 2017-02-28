class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_theme

  protected

  def set_theme
    if params[:theme].present? && (THEMES.include?(params[:theme]) || params[:theme] == "cosmo")
      @theme = params[:theme]
      session[:theme] = params[:theme]
    else
      @theme ||= session[:theme] || "cosmo"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :device_eui])
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_url, alert: t("flash.users.unauthorized")
    end
  end
end

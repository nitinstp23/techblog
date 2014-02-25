class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  protected

  def authenticate
    redirect_to new_session_url unless signed_in?
  end

  def current_user
    session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  helper_method :current_user
  helper_method :signed_in?

end

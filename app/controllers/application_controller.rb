class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :app_key, :logged_in?, :access_token

  def logged_in?
    !!access_token
  end

  def access_token
    session[:access_token]
  end

  def app_key
    Rails.application.secrets.app_key
  end
end

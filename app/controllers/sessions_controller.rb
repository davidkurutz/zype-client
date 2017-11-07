require 'http'

class SessionsController < ApplicationController
  def new; end

  def create
    t = token(params[:username], params[:password])
    if t.status.success?
      login_user!(t)
      redirect_to "/videos/#{params[:video_id]}"
    else
      flash[:error] = "There is something wrong with your username or password"
      redirect_to login_path(:video_id => params[:video_id])
    end
  end

  def destroy
    session[:access_token] = nil
    flash[:notice] = "You've logged out."
    redirect_to root_path
  end

  private

  def token(username, password)
    HTTP.post(login_url(username, password))
  end

  def login_user!(token)
    session[:access_token] = JSON.parse(token)['access_token']
    flash[:notice] = "You have successfully logged in"
  end

  def login_url(username, password)
    "https://login.zype.com/oauth/token/?client_id=#{client_id}&client_secret=#{client_secret}&username=#{username}&password=#{password}&grant_type=password"
  end

  def client_id
    Rails.application.secrets.client_id
  end

  def client_secret
    Rails.application.secrets.client_secret
  end
end
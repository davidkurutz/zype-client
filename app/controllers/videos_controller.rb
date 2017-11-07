require 'http'

class VideosController < ApplicationController
  helper_method :embed_url

  def index
    response = JSON.parse(HTTP.get(videos_url(params['page'] || 1)))
    @videos = response['response']
    pagination = response['pagination']
    @prev = pagination['previous']
    @nxt = pagination['next']
  end

  def show
    @video_id = params[:id]
    response = JSON.parse(HTTP.get(video_url(@video_id)))
    check_subscription(response)
  end

  private

  def check_subscription(response)
    if response['response']['subscription_required'] && !logged_in?
      flash[:error] = "This video is for subscribers only. Please log in."
      redirect_to login_path(:video_id => @video_id)
    end
  end

  def video_url(id = nil)
    "https://api.zype.com/videos#{ id ? '/' + id : ''}" + "?app_key=#{app_key}"
  end

  def videos_url(page)
    video_url + "&per_page=12&page=#{page}"
  end

  def embed_url(video_id)
    prefix = "https://player.zype.com/embed/#{video_id}.js?autoplay=true"
    prefix + (logged_in? ? "&access_token=#{access_token}" : "&app_key=#{app_key}")
  end
end
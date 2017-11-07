require 'http'

class VideosController < ApplicationController
  helper_method :embed_url

  def index
    page = params['page'] || 1
    response = JSON.parse(HTTP.get(videos_url(page)))
    @videos = response['response']
    pagination = response['pagination']
    @prev = pagination['previous']
    @nxt = pagination['next']
  end

  def show
    @video_id = params[:id]
    response = JSON.parse(HTTP.get(video_url(@video_id)))

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
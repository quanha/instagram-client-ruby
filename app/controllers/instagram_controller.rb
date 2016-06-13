require "instagram"

class InstagramController < ApplicationController

  before_filter :auth, only: [:feed, :tags, :tags_result]
  before_filter :get_client,  only: [:feed, :tags, :tags_result]

  def auth
    redirect_to :controller => 'instagram' if !session[:access_token]
  end

  def index
    redirect_to :controller => 'instagram', :action => 'feed' if session[:access_token]
  end

  def feed
    @user = @client.user
    @recent_media_items = @client.user_recent_media
    @title = 'Home Page'
  end

  def tags
    if params[:q].present?
      @tags = @client.tag_search(params[:q])
    end
    @user = @client.user
    @title = 'HashTags'
  end

  def tags_result
    @tag_result = @client.tag_recent_media(params[:hashtag]) # Get the recent Instagram post or comment using hashtag
    @posts = @tag_result.paginate(:page => params[:page], :per_page => 10)
    @user = @client.user
  end

  private

  def get_client
    @client = Instagram.client(:access_token => session[:access_token])
  end
end

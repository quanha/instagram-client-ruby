require "instagram"

class InstagramController < ApplicationController

  before_filter :auth, only: [:feed, :tags, :tags_result]

  def auth
    redirect_to :controller => 'instagram' if !session[:access_token]
  end

  def index
    redirect_to :controller => 'instagram', :action => 'feed' if session[:access_token]
  end

  def feed
    client = Instagram.client(:access_token => session[:access_token])
    @user = client.user
    @recent_media_items = client.user_recent_media
    @title = 'Home Page'
  end

  def tags
    client = Instagram.client(:access_token => session[:access_token])
    if params[:q].present?
      hashtag = params[:q]
      @tags = client.tag_search(hashtag)
    end
    @user = client.user
    @title = 'HashTags'
  end

  def tags_result
    client = Instagram.client(:access_token => session[:access_token])
    hashtag = '#'+params[:hashtag]
    @tag_result = client.tag_recent_media(params[:hashtag]) # Get the recent Instagram post or comment using hashtag

    instagrammers = Hash.new # Top commenters using hashtags
    for item in @tag_result
      username = item[:user][:username]
      caption = item[:caption][:text]
      id = item[:id]

      # Find post using hashtag
      if(caption.include? hashtag)
        update_hash(instagrammers, username)
      end

      # Find comment using hashtag
      comments = client.media_comments(id)  # Get the recent comment list of its posts
      for k in comments
        commenter = k[:from][:username]
        comment = k[:text]
        if(comment.include? hashtag)
          update_hash(instagrammers, commenter)
        end
      end
    end


    posts = Array.new  # Recent comments using hashtag
    for item in @tag_result
      username = item[:user][:username]
      caption = item[:caption][:text]
      post_date = item[:caption][:created_time]
      id = item[:id]

      # Find post using hashtag
      if(caption.include? hashtag)
        posts.push([username, caption, post_date])
      end

      # Find comment using hashtag
      comments = client.media_comments(id) # Get the recent comment list of its posts
      for k in comments
        commenter = k[:from][:username]
        comment = k[:text]
        comment_date = k[:created_time]
        if(comment.include? hashtag)
          posts.push([commenter, comment, comment_date])
        end
      end
    end
    posts = posts.sort {|a,b| a[2] <=> b[2]}

    @user = client.user
    @title = 'HashTag Results'
    @hashtag = hashtag
    @instagrammers = instagrammers.sort_by {|_key, value| value}.reverse
    @posts = posts.paginate(:page => params[:page], :per_page => 10)
  end

  def update_hash(hash, key)
    if hash.has_key?(key)
      hash[key] += 1
    else
      hash[key] = 1
    end
  end
end

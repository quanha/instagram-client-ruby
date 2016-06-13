require "instagram"

class SessionController < ApplicationController
  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL, :scope => ['public_content','basic'])
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    session[:access_token] = response.access_token
    redirect_to :controller => 'instagram', :action => 'feed'
  end

  def logout
    session.delete(:access_token)
    redirect_to :controller => 'instagram'
  end
end

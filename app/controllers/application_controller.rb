class ApplicationController < ActionController::Base
  protect_from_forgery


  def request_chat
    current_user.update_attribute(:chat_requested, true)
    redirect_to '/chats'
  end

  private


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    if current_user.nil?
      flash[:error] = "please authenticate first" 
      redirect_to "/"   
    end 
  end
  helper_method :current_user
end

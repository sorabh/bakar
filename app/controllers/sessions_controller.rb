class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    current_user.update_attribute(:chat_requested, false)
    delete_room()
    session[:user_id] = nil
    redirect_to root_url
  end

  def delete_room
    uri = URI("https://api.hipchat.com/v2/room/#{current_user.room_id}?auth_token=#{ENV['HIPCHAT_TOKEN']}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    response = http.request(request)
  end  
end
require 'uri'
require 'net/http'

class UsersController < ApplicationController

  def request_chat
    @interested_user = get_interested_user
    if @interested_user
      current_user.update_attribute(:chat_requested, false)
      @interested_user.update_attribute(:chat_requested, false)
      guest_url = @interested_user.guest_url
    else
      if current_user.guest_url.nil?
        current_user.update_attribute(:chat_requested, true)
        guest_url = create_room()
        current_user.update_attribute(:guest_url, guest_url)
      end  
    end

    redirect_to "/chats"   
  end

  def create_room()

    uri = URI("https://api.hipchat.com/v2/room?auth_token=#{ENV['HIPCHAT_TOKEN']}")
    req = Net::HTTP::Post.new(uri)

    @data = {"privacy" => "public" ,"guest_access" => true,"topic"=>"", "name" => "Bakar_#{current_user.id}" }.to_json
    req.body = @data
    req.content_type = 'application/json'
    request = Net::HTTP.new(uri.hostname, uri.port)
    request.use_ssl = true
    request.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @res = request.start  do |http|
      http.request(req)
    end
    room_id =  JSON.parse(@res.body)["id"]
    current_user.update_attribute(:room_id, room_id)


    #get request to extract guest url from room
    uri2 = URI("https://api.hipchat.com/v2/room/#{room_id}?auth_token=#{ENV['HIPCHAT_TOKEN']}")
    http = Net::HTTP.new(uri2.host, uri2.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri2.request_uri)
    response = http.request(request)
    JSON.parse(response.body)["guest_access_url"]
  end

  def get_interested_user()
    location_id = current_user.location_id
    User.where(location_id:location_id, chat_requested: true).sample

  end
end
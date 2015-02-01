require 'uri'
require 'net/http'

class UsersController < ApplicationController

  def request_chat
    current_user.update_attribute(:chat_requested, true)
    @interested_user = get_interested_user
    if @interested_user
      current_user.update_attribute(:chat_requested, false)
      @interested_user.update_attribute(:chat_requested, false)
      @guest_url = @interested_user.guest_url
    else
      @guest_url = create_room()
      current_user.update_attribute(:guest_url, @guest_url)
    end
  end

  def create_room()
    uri = URI("https://api.hipchat.com/v2/room?auth_token=#{ENV['HIPCHAT_TOKEN']}")
    req = Net::HTTP::Post.new(uri)
    req.use_ssl = true
    @data = File.read("app/assets/json/hipchat_create.json")
    @data["name"] = "Bakar_#{current_user.id}"
    req.body = @data
    req.content_type = 'application/json'
    response = https.request(req)
    room_id = response['id']

    #get request to extract guest url from room
    uri2 = URI("https://api.hipchat.com/v2/room/#{room_id}?auth_token=#{ENV['HIPCHAT_TOKEN']}")
    req_get = Net::HTTP::GET.new(uri)
    req_get.use_ssl = true
    response_get = https.request(req_get)
    response_get['guest_access_url']
  end

  def get_interested_user()
    location_id = current_user.location_id
    User.where(location_id:location_id, chat_requested: true).sample

  end
end
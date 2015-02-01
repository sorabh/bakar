class UsersController < ApplicationController

  def request_chat
    current_user.update_attribute(:chat_requested, true)
    @interested_user = get_interested_user

    unless @interested_user.nil?
      redirect_to '/chats'
    else
      redirect_to '/home', notice: "No user available to chat"
    end
  end

  def get_interested_user()
    location_id = current_user.location_id
    User.where(location_id:location_id, chat_requested: true).sample

  end
end
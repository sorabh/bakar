class ChatsController < ApplicationController
  # GET /chats
  # GET /chats.json
  before_filter :authenticate_user!
  layout 'application'
  def index

  end

end

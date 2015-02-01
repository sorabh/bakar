class Message < ActiveRecord::Base
  attr_accessible :receiver_id, :sender_id, :value

  belongs_to :chat
  belongs_to :sender
  belongs_to :receiver,


end
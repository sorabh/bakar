class AddChatRequestedToUser < ActiveRecord::Migration
  def change
    add_column :users, :chat_requested, :boolean
    add_index :users, :chat_requested
  end
end

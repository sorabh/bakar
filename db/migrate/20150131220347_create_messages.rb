class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :value
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :chat_id

      t.timestamps
    end

  end
end

class AddGuestUrlToUser < ActiveRecord::Migration
  def change
  	add_column :users, :guest_url, :string
  end
end

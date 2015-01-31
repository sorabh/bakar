class Location < ActiveRecord::Base
  has_many :users
  attr_accessible :id, :name

  def self.from_omniauth(user_location)
    where(user_location.slice(:id)).first_or_initialize.tap do |location|
      location.id = user_location.id
      location.name = user_location.name
      location.save!
    end
  end
end

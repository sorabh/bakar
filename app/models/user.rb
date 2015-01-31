class User < ActiveRecord::Base
  belongs_to :location

  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.location_id = Location.from_omniauth(auth.extra.raw_info.location).id
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end

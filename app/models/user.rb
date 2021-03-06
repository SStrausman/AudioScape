class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :address
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:twitter]
  has_many :playlists
  has_many :songs, through: :playlists
  geocoded_by :address   # can also be an IP address
  after_validation :geocode
  # geocoded_by :address, :latitude  => :latitude, :longitude => :longitude
  # after_validation :geocode
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode
  # geocoded_by :address, :latitude  => :lat, :longitude => :lon

  # extract the information that is available after the authentication.
	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
		user.provider = auth.provider
		user.uid = auth.uid
		user.username = auth.uid
		user.email = auth.info.email
		user.password = Devise.friendly_token[0,20]

		end
	end
end

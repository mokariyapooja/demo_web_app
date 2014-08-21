class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #paperclip_attachment
  has_attached_file :photo, :styles => { :small => "150x150", :large => "320x240" }, 
                    :url => "/assets/gallery/:id/:style/:basename.:extention",
                    :path => "#{Rails.root}/public/assets/gallery/:id/:style/:basename.:extention"

  # #validations
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  acts_as_followable
  acts_as_follower 

  has_many :albums 

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.photo = auth.info.photo
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save(:validate => false)
    end
  end

  def fetch_facebook_albums
    @graph = self.get_graph_object
    profile = @graph.get_object("me")
    albums = @graph.get_connections("me", "albums") 
    return albums 
  end

  def get_graph_object
    Koala::Facebook::API.new(self.oauth_token)
  end
end 
  
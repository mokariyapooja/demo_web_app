class Photo < ActiveRecord::Base
  belongs_to :album

  #paperclip_attachment
  has_attached_file :data, :styles => { :small => "150x150", :large => "320x240" },                     
                    :url => "/assets/gallery/:id/:style/:basename.:extention",
                    :path => "#{Rails.root}/public/assets/gallery/:id/:style/:basename.:extention"
                   
  #validations
  validates_attachment_content_type :data, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
    
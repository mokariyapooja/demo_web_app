class Album < ActiveRecord::Base
  has_many :photos 
  belongs_to :user
  accepts_nested_attributes_for :photos
  
  PRIVACY = ["private","public","visible to friends"]
end
 
class Album < ActiveRecord::Base
  has_many :photos 
  belongs_to :user
  accepts_nested_attributes_for :photos
  
  PRIVACY = ["private","public","visible to friends"]

  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => :all_blank

  #fatch value from array
  def privacy_value
    PRIVACY[self.privacy]
  end
end
  
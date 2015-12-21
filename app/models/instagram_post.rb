class InstagramPost < ActiveRecord::Base
  validates_uniqueness_of :instagram_id
  validates_presence_of :instagram_id, :time, :user_id, :url

  belongs_to :user

  def display
  end
end

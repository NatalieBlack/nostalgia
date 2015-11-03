class Tweet < ActiveRecord::Base
  validates_uniqueness_of :twitter_id
  validates_presence_of :twitter_id, :time, :user_id, :url

  belongs_to :user

  def display
    $twitter.oembed(twitter_id).html
  end
end

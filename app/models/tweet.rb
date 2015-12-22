class Tweet < ActiveRecord::Base
  include Memory
  validates_uniqueness_of :twitter_id
  validates_presence_of :twitter_id, :time, :user_id, :url

  belongs_to :user

  def display
    "<div class=\"tweet_outer\">#{$twitter.oembed(twitter_id).html}</div>".html_safe
  end
end

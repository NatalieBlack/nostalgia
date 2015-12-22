class Tweet < ActiveRecord::Base
  include Memory
  validates_uniqueness_of :twitter_id
  validates_presence_of :twitter_id, :time, :user_id, :url

  belongs_to :user

  def display
    "<div class=\"tweet_outer\">#{$twitter.oembed(twitter_id).html}</div>".html_safe
  end

  def self.history_for_user(u)
      Rails.logger.info "tumblr history for #{u.name}"
      created = []

      tweets = Memory.collect_tweets_with_max_id(u) do |max_id|
          Rails.logger.info "calling twiter API until #{max_id}"
          options = {count: 200, include_rts: false}
          options[:max_id] = max_id unless max_id.nil?
          $twitter.user_timeline(u.twitter_name, options)
      end
      
      tweets.each do |tweet|

        break if u.tweets.find_by(twitter_id: tweet.id.to_s)

        Rails.logger.info "creating tweet #{tweet.created_at}"

          created << Tweet.create( {
              user_id: u.id,
              time: tweet.created_at.to_datetime,
              text: tweet.full_text,
              twitter_id: tweet.id,
              url: tweet.url
          })
      end
      return created 
  end

end

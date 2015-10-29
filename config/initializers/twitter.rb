$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TW_CONSUMER_KEY']
  config.consumer_secret = ENV['TW_CONSUMER_SECRET']
end

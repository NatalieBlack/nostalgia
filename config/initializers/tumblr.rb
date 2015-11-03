#Tumblr.configure do |config|
  #config.consumer_key = Figaro.env.tm_consumer_key
  #config.consumer_secret = Figaro.env.tm_consumer_secret
#end
$tumblr = Tumblr::Client.new({
  :consumer_key => ENV['TM_CONSUMER_KEY'],
  :consumer_secret => ENV['TM_CONSUMER_KEY'],
  :oauth_token => ENV['TM_OAUTH_TOKEN'],
  :oauth_token_secret => ENV['TM_OAUTH_SECRET']
})


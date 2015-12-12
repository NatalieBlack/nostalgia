Instagram.configure do |config|
  config.client_id = Figaro.env.insta_id
  config.client_secret = Figaro.env.insta_secret
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end

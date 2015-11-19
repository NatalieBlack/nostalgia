class TumblrPost < ActiveRecord::Base
  has_many :tags, class_name: 'TumblrTags'
  def display 
    html = HTTParty.get("#{url}/embed").body
    embed_code = html.scan( /embed_key":"([^"]*)"/)[0][0]
    embed_did = html.scan( /embed_did":"([^"]*)"/)[0][0]
    
    html = "<div class=\"tumblr_post_outer\"><div class=\"tumblr-post\" data-href=\"https://embed.tumblr.com/embed/post/#{embed_code}/#{tumblr_id}\" data-did=\"#{embed_did}\"><a href=\"#{url}\">#{url}</a></div><script async src=\"https://secure.assets.tumblr.com/post.js\"></script></div>"
    html.html_safe
  end
end

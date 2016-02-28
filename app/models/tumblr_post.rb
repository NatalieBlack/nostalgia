class TumblrPost < ActiveRecord::Base
  include Memory

  def display 
    html = HTTParty.get("#{url}/embed").body
    embed_code = html.scan( /embed_key&quot;:&quot;([\w]*)&quot;/)[0][0]
    embed_did = html.scan( /embed_did&quot;:&quot;([\w]*)&quot;/)[0][0]
    
    html = "<div class=\"tumblr_post_outer\"><div class=\"tumblr-post\" data-href=\"https://embed.tumblr.com/embed/post/#{embed_code}/#{tumblr_id}\" data-did=\"#{embed_did}\"><a href=\"#{url}\">#{url}</a></div><script async src=\"https://secure.assets.tumblr.com/post.js\"></script></div>"
    html.html_safe
  end

  def self.history_for_user(u)
      Rails.logger.info "tumblr history for #{u.name}"

      created = []

      posts = Memory.collect_posts_with_offset(u) do |offset|
        Rails.logger.info "calling tumblr API until #{offset}"
        options = {}
        options[:offset] = offset unless offset.nil?
        $tumblr.posts(u.tumblr_url.gsub(/http:\/\//,''), options)['posts']
      end

      posts.each do |p|
        break if u.tumblr_posts.find_by(tumblr_id: p['id'])
        Rails.logger.info "creating tumblr post #{p['id']}"

        new_post = TumblrPost.create({
          user_id: u.id,
          tumblr_id: p['id'],
          time: Memory.convert_timestamp(p['timestamp']),
          url: p['post_url']
        })

        created << new_post
      end
      return created 
  end

end

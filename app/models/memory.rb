class Memory
  BASE_INSTAGRAM_URL = 'https://www.instagram.com' 
  def self.history_for_user(u)
    Rails.logger.info "importing memories for #{u.name}"
    tweets = twitter_history_for_user(u)
    posts = tumblr_history_for_user(u)
    memories = tweets + posts
    Rails.logger.info "done importing #{memories.count} memories for #{u.name}"
    return memories
  end

  def self.instagram_history_for_user(u)
      Rails.logger.info "instagram history for #{u.name}"
      created = []

      posts = collect_instagram_posts_with_max_id(u) do |id|
        Rails.logger.info "calling instagram API until #{id}"
        url = "#{BASE_INSTAGRAM_URL}/#{u.instagram_name}/media"
        url += "?max_id=#{id}" unless id.nil?
        r = HTTParty.get(url)
        r['items']
      end

      posts.each do |p|
        break if u.instagram_posts.find_by(instagram_id: p['id'])
        Rails.logger.info "creating instagram post #{p['id']}"

        new_post = InstagramPost.create({
          user_id: u.id,
          instagram_id: p['id'],
          time: convert_timestamp(p['created_time']),
          url: p['link']
        })
      end
  end

  def self.tumblr_history_for_user(u)
      Rails.logger.info "tumblr history for #{u.name}"

      created = []

      posts = collect_posts_with_offset(u) do |offset|
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
          time: convert_timestamp(p['timestamp']),
          url: p['post_url']
        })
        p['tags'].each do |t|
            TumblrTag.create({
                tumblr_post_id: new_post.id,
                content: t
            })
        end

        created << new_post
      end
      return created 
  end

  def self.twitter_history_for_user(u)
      Rails.logger.info "tumblr history for #{u.name}"
      created = []

      tweets = collect_tweets_with_max_id(u) do |max_id|
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

private
  def self.convert_timestamp(timestamp_int)
    DateTime.strptime(timestamp_int.to_s, '%s')
  end

  def self.collect_tweets_with_max_id(user, collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    ids = response.map(&:id)
    if response.empty? || user.tweets.where(twitter_id: ids).any?
      collection.flatten
    else
      collect_tweets_with_max_id(user, collection, response.last.id - 1, &block)
    end
  end

  def self.collect_posts_with_offset(user, collection=[], offset=0, &block)
    response = yield(offset)
    collection += response
    new_offset = offset + 20
    ids = response.map { |p| p['id'] }
    if response.empty? || user.tumblr_posts.where(tumblr_id: ids).any?
      collection.flatten
    else
      collect_posts_with_offset(user, collection, new_offset, &block)
    end
  end

  def self.collect_instagram_posts_with_max_id(user, collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    collection.uniq!
    ids = response.map { |i| i['id']}
    if response.empty? || user.instagram_posts.where(instagram_id: ids).any?
      collection.flatten
    else
      collect_instagram_posts_with_max_id(user, collection, response.last['id'], &block)
    end
  end


end

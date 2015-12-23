module Memory
  BASE_INSTAGRAM_URL = "https://www.instagram.com"

  def self.history_for_user(u)
    Rails.logger.info "importing memories for #{u.name}"
    tweets = Tweet.history_for_user(u)
    tposts = TumblrPost.history_for_user(u)
    iposts = InstagramPost.history_for_user(u)
    memories = tweets + tposts + iposts
    Rails.logger.info "done importing #{memories.count} memories for #{u.name}"
    return memories
  end

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


end

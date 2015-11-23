class Memory
  def self.history_for_user(u)
    puts "history for #{u.name}"
    twitter_history_for_user(u)
    tumblr_history_for_user(u)
  end

  def self.tumblr_history_for_user(u)
      posts = $tumblr.posts(u.tumblr_url)
      posts = posts['posts']

      posts.each do |p|
        new_post = TumblrPost.create({
          user_id: u.id,
          tumblr_id: p['id'],
          time: convert_tumblr_time(p['timestamp']),
          url: p['post_url']
        })
        p['tags'].each do |t|
            TumblrTag.create({
                tumblr_post_id: new_post.id,
                content: t
            })
        end
      end
  end

  def self.twitter_history_for_user(u)
      tweets = collect_with_max_id do |max_id|
          options = {count: 200, include_rts: false}
          options[:max_id] = max_id unless max_id.nil?
          $twitter.user_timeline(u.twitter_name, options)
      end
      
      tweets.each do |tweet|
        puts "creating tweet #{tweet.created_at}"
          Tweet.create( {
              user_id: u.id,
              time: tweet.created_at.to_datetime,
              text: tweet.full_text,
              twitter_id: tweet.id,
              url: tweet.url
          })
      end
  end

  def self.latest_for_user(u)
    twitter_latest_for_user(u)
    tumblr_latest_for_user(u)
  end

  def self.tumblr_latest_for_user(u)
  end

  def self.twitter_latest_for_user(u)
      loop do
          tweets = $twitter.user_timeline(u.twitter_name, {include_rts: false})
          tweets.each do |tw|
              break unless Tweet.create( {
                  user_id: u.id,
                  time: tweet.created_at.to_datetime,
                  text: tweet.full_text,
                  twitter_id: tweet.id,
                  url: tweet.url
              }) #stop looping if we aren't storing new tweets
          end
          break if u.tweets.find_by(twitter_id: tweets.last.id) #stop calling API if we got all the new tweets
      end
  end

private
  def self.convert_tumblr_time(timestamp_int)
    DateTime.strptime(timestamp_int.to_s, '%s')
  end

  def self.collect_with_max_id(collection=[], max_id=nil, &block)
  puts max_id
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

end
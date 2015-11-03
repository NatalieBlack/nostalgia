namespace :import do
  desc "import twitter history"
  task :twitter_history => :environment do

      User.all.each do |u|

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
  end

  desc "import tumblr history"

  task :tumblr_history => :environment do

    User.all.each do |u|

      posts = $tumblr.posts(u.tumblr_url, limit: 10)
      posts = posts['posts']

      posts.each do |p|
        new_post = TumblrPost.create({
          user_id: u.id,
          tumblr_id: p['id'],
          time: convert_tumblr_time(p['timestamp']),
          url: p['post_url']
        })
        p.tags.each do |t|
            new_post.tags.create({
                content: t
            })
        end
      end

      end
    end

  end

end

namespace :import_latest do
  desc "import latest tweets "
  task :twitter_latest => :environment do
      User.all.each do |u|
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
  end
end

def collect_with_max_id(collection=[], max_id=nil, &block)
puts max_id
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def convert_tumblr_time(timestamp_int)
  DateTime.strptime(timestamp_int.to_s, '%s')
end


class FacebookPost < ActiveRecord::Base
  include Memory
  validates_uniqueness_of :facebook_id
  validates_presence_of :facebook_id, :time, :user_id

  belongs_to :user

  def display
  end

  def self.history_for_user(u)
      Rails.logger.info "facebook history for #{u.name}"
      created = []

      posts = collect_posts(u).select{|p| p['message'] }

      posts.each do |p|
        break if u.facebook_posts.find_by(facebook_id: p['id'])
        Rails.logger.info "creating facebook post #{p['id']}"

        new_post = FacebookPost.create({
          user_id: u.id,
          facebook_id: p['id'],
          time: Memory.convert_timestamp(p['created_time']),
          message: p['message'],
        })
      end

      posts
  end

  private

  def self.collect_posts(user)
    client = user.fb_client
    response = client.get_connection('me', 'posts') 
    total = response

    while(response.next_page.any?)
      Rails.logger.info "calling facebook API until #{response.last['id']}"
      total += response.next_page
    end
    total.flatten.uniq
  end
end


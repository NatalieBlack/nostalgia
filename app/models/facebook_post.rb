class FacebookPost < ActiveRecord::Base
  include Memory
  LIMIT = 25

  validates_uniqueness_of :facebook_id
  validates_presence_of :facebook_id, :time, :user_id

  belongs_to :user

  def display
    "<div class=\"fb_outer\"><p>#{message}</p></div>".html_safe
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

        created << new_post
      end

      created 
  end

  private

  def self.collect_posts(user)
    client = user.fb_client
    response = client.get_connection('me', 'posts') 
    total = []

    while(response.any?)
      Rails.logger.info "calling facebook API until #{response.last['id']}"
      total += response
      u = response.next_page_params.last["until"]
      pt = response.next_page_params.last["__paging_token"]
      opts = {limit: LIMIT, until: u, "__paging_token": pt}
      response = client.get_connection('me', 'posts', opts)
    end
    total.flatten.uniq
  end
end


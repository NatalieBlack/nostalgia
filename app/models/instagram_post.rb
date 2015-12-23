class InstagramPost < ActiveRecord::Base
  include Memory
  validates_uniqueness_of :instagram_id
  validates_presence_of :instagram_id, :time, :user_id, :url

  belongs_to :user

  def display
    "<div class=\"instagram_embed\"><img src=\"#{image_url}\" height=\"#{height}\" width=\"#{width}\">
     <p>#{caption}</p></div>".html_safe
  end

  def self.history_for_user(u)
      Rails.logger.info "instagram history for #{u.name}"
      created = []

      posts = collect_posts_with_max_id(u) do |id|
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
          time: Memory.convert_timestamp(p['created_time']),
          image_url: p['images']['standard_resolution']['url'],
          height:p['images']['standard_resolution']['height'],
          width: p['images']['standard_resolution']['width'],
          caption: try_caption(p),
          url: convert_ig_link(p['link'])
        })
      end
  end

  private
  def self.convert_ig_link(url)
    url.gsub(/www\./, '')
  end

  def self.try_caption(p)
    p['caption'] ? p['caption']['text'] : ''
  end

  def self.collect_posts_with_max_id(user, collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    collection.uniq!
    ids = response.map { |i| i['id']}
    if response.empty? || user.instagram_posts.where(instagram_id: ids).any?
      collection.flatten
    else
      collect_posts_with_max_id(user, collection, response.last['id'], &block)
    end
  end

end

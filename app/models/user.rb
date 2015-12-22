class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, :dependent => :destroy
  has_many :tumblr_posts, :dependent => :destroy
  has_many :instagram_posts, :dependent => :destroy

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_uniqueness_of :twitter_name, :tumblr_url, :instagram_name

  def memories
    tweets + tumblr_posts + instagram_posts
  end

  def sources_to_import
    sources = []
    potential = {twitter: twitter_name, tumblr: tumblr_url, instagram: instagram_name}

    potential.each do |k, v|
      sources << k.to_s unless v.nil?
    end

    return sources

  end

  def imported?(source)
    if source == "twitter"
      return tweets.any?
    elsif source == "tumblr"
      return tumblr_posts.any?
    elsif source == "instagram"
      return instagram_posts.any?
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def chance_of_new_memories?
    memories.any? &&
    (
      ((twitter_name && tweets.empty?) || (tumblr_url && tumblr_posts.empty?) ||
       (instagram_name && instagram_posts.empty?)) ||
      [
      tweets.maximum(:created_at),
      instagram_posts.maximum(:created_at),
      tumblr_posts.maximum(:created_at)
      ].compact.max < 1.month.ago
    )
  end

end

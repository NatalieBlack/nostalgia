class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :tweets, :dependent => :destroy
  has_many :tumblr_posts, :dependent => :destroy
  has_many :instagram_posts, :dependent => :destroy
  has_many :facebook_posts, :dependent => :destroy
  has_many :identities

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_uniqueness_of :twitter_name, :tumblr_url, :instagram_name, :facebook_username

  def memories
    tweets + tumblr_posts + instagram_posts + facebook_posts
  end

  def destroy_memories
    (
    tweets.destroy_all &&
    tumblr_posts.destroy_all &&
    instagram_posts.destroy_all
    )
  end

  def sources_to_import
    sources = []
    potential = {twitter: twitter_name, tumblr: tumblr_url, instagram: instagram_name, facebook: facebook_username}

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
    elsif source == "facebook"
      return facebook_posts.any?
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def chance_of_new_memories?
    memories.any? &&
    (
      ((twitter_name && tweets.empty?) || (tumblr_url && tumblr_posts.empty?) ||
       (instagram_name && instagram_posts.empty?) || (facebook_username && facebook_posts.empty?)) ||
      [
      tweets.maximum(:created_at),
      instagram_posts.maximum(:created_at),
      facebook_posts.maximum(:created_at),
      tumblr_posts.maximum(:created_at)
      ].compact.max < 1.month.ago
    )
  end

  def fb_client
    Koala::Facebook::API.new(identities.find_by(provider: :facebook).accesstoken)
  end

  def needs_to_auth?
    facebook_username && identities.find_by(provider: :facebook).nil?
  end

end

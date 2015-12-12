class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

  has_many :tweets, :dependent => :destroy
  has_many :tumblr_posts, :dependent => :destroy
  has_many :identities

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_uniqueness_of :twitter_name, :tumblr_url

  def memories
    tweets + tumblr_posts
  end

  def sources_to_import
    sources = []
    potential = {twitter: twitter_name, tumblr: tumblr_url}

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
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def chance_of_new_memories?
    memories.any? &&
    (
      ((twitter_name && tweets.empty?) || (tumblr_url && tumblr_posts.empty?)) ||
      [
      tweets.maximum(:created_at),
      tumblr_posts.maximum(:created_at)
      ].compact.max < 1.month.ago
    )
  end


  def instagram
    identities.where( :provider => "instagram" ).first
  end

  def instagram_client
    @instagram_client ||= Instagram.client( access_token: instagram.accesstoken )
  end

end

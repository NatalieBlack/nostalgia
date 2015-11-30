class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, :dependent => :destroy
  has_many :tumblr_posts, :dependent => :destroy

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


end

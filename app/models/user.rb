class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets
  has_many :tumblr_posts

  after_create :load_memories
  
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates_uniqueness_of :twitter_name, :tumblr_url

  def memories
    tweets + tumblr_posts
  end

  def load_memories
    ImportMemoriesJob.perform_later(self)
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end


end

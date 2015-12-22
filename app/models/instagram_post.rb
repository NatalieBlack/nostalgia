class InstagramPost < ActiveRecord::Base
  include Memory
  validates_uniqueness_of :instagram_id
  validates_presence_of :instagram_id, :time, :user_id, :url

  belongs_to :user

  def display
    "<div class=\"instagram_embed\"><img src=\"#{image_url}\" height=\"#{height}\" width=\"#{width}\">
     <p>#{caption}</p></div>".html_safe
  end
end

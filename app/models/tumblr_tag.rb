class TumblrTag < ActiveRecord::Base
  belongs_to :post, class_name: 'TumblrPost', foreign_key: :tumblr_post_id
end

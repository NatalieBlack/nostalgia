class TumblrTag < ActiveRecord::Base
  belongs_to :post, class_name: 'TumblrPost'
end

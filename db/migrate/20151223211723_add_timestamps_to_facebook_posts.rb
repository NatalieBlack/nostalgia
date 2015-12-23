class AddTimestampsToFacebookPosts < ActiveRecord::Migration
  def change
    add_column :facebook_posts, :created_at, :datetime
    add_column :facebook_posts, :updated_at, :datetime
  end
end

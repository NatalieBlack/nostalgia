class AddImageUrlToInstagramPosts < ActiveRecord::Migration
  def change
    add_column :instagram_posts, :image_url, :string
  end
end

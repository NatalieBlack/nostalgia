class AddFieldsToInstagramPosts < ActiveRecord::Migration
  def change
    add_column :instagram_posts, :caption, :string
    add_column :instagram_posts, :height, :integer
    add_column :instagram_posts, :width, :integer
  end
end

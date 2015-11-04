class ChangeTumblrIdToString < ActiveRecord::Migration
  def change
    change_column :tumblr_posts, :tumblr_id, :string
  end
end

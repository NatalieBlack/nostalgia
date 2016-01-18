class DropTumblrTags < ActiveRecord::Migration
  def change
    drop_table :tumblr_tags
  end
end

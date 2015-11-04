class CreateTumblrPosts < ActiveRecord::Migration
  def change
    create_table :tumblr_posts do |t|
      t.integer :user_id
      t.string :url
      t.integer :tumblr_id
      t.datetime :time

      t.timestamps null: false
    end
  end
end

class CreateInstagramPosts < ActiveRecord::Migration
  def change
    create_table :instagram_posts do |t|
      t.string :url
      t.integer :user_id
      t.string :instagram_id
      t.datetime :time

      t.timestamps null: false
    end
  end
end

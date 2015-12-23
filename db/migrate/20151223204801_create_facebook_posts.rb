class CreateFacebookPosts < ActiveRecord::Migration
  def change
    create_table :facebook_posts do |t|
      t.string :message
      t.string :facebook_id
      t.datetime :time
      t.integer :user_id
    end
  end
end

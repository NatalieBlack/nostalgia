class CreateTumblrTags < ActiveRecord::Migration
  def change
    create_table :tumblr_tags do |t|
      t.string :content
      t.integer :tumblr_post_id

      t.timestamps null: false
    end
  end
end

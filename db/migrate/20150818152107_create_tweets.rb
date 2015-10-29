class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :twitter_id
      t.text :text
      t.datetime :time
      t.integer :user_id
      t.string :url
      t.text :embedded_html

      t.timestamps null: false
    end

    add_index :tweets, :user_id
  end
end

class AddInstagramNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram_name, :string
  end
end

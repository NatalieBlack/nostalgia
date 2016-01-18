class AddAccessTokenAndRefreshTokenToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :accesstoken, :string
    add_column :identities, :refreshtoken, :string
  end
end

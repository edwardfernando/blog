class AddAdditionalInformationToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_expires_at, :string
    add_column :users, :kaskus_id, :string
    add_column :users, :kaskus_auth_token, :string
    add_column :users, :kaskus_is_verify, :boolean
    add_column :users, :kaskus_verify_date, :datetime
    add_column :users, :avatar_url, :string
    add_column :users, :profile_is_complete, :boolean
    add_column :users, :random_id, :string
  end
end

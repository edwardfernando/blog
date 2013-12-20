class AddAdditionalInformationToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :thread_id, :string
    add_column :websites, :thread_create_date, :string
  end
end

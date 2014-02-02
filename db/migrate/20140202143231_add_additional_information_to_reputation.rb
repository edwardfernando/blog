class AddAdditionalInformationToReputation < ActiveRecord::Migration
  def change
  	add_column :reputations, :accurate_description, :integer
  	add_column :reputations, :communication, :integer
  	add_column :reputations, :shipping_speed, :integer
  	add_column :reputations, :shipping_cost, :integer
  end
end

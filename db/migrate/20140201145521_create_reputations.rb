class CreateReputations < ActiveRecord::Migration
  def change
    create_table :reputations do |t|
      t.integer :rating
      t.integer :accurate_accuration
      t.integer :communication
      t.integer :shipping_speed
      t.integer :shipping_cost
      t.references :testimonial, index: true
      t.timestamps
    end
  end
end

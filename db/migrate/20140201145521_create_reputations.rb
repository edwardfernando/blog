class CreateReputations < ActiveRecord::Migration
  def change
    create_table :reputations do |t|
      t.integer :rating
      t.references :testimonial, index: true
      t.timestamps
    end
  end
end

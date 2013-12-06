class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :name
      t.string :comment
      t.string :sex
      t.string :location
      t.integer :age
      t.boolean :approved

      t.timestamps
    end
  end
end

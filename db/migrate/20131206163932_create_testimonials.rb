class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.text :comment
      t.references :website, index: true
      t.references :user, index: true

      t.references :user, index: true

      t.timestamps
    end
  end
end

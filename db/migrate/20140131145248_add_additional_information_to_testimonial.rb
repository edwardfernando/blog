class AddAdditionalInformationToTestimonial < ActiveRecord::Migration
  def change
    add_column :testimonials, :random_id, :string
    add_column :testimonials, :rating, :integer
    add_column :testimonials, :accurate_description, :integer
    add_column :testimonials, :communication, :integer
    add_column :testimonials, :shipping_speed, :integer
    add_column :testimonials, :shipping_cost, :integer
  end
end

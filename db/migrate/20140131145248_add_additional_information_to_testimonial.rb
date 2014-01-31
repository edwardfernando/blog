class AddAdditionalInformationToTestimonial < ActiveRecord::Migration
  def change
    add_column :testimonials, :random_id, :string
  end
end

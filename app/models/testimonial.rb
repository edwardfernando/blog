class Testimonial < ActiveRecord::Base
	belongs_to :website
	belongs_to :user

	has_many :reputation, dependent: :destroy         
end

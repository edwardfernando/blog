class Website < ActiveRecord::Base
	has_many :testimonials, dependent: :destroy
end

class Website < ActiveRecord::Base
	has_many :testimonials, dependent: :destroy
	belongs_to :user


	def self.find_by_user(user_id)
		return Website.where(:user_id => user_id)
	end
end

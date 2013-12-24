class Website < ActiveRecord::Base
	has_many :testimonials, dependent: :destroy
	belongs_to :user


	def self.find_by_user(user_id)
		return Website.where(:user_id => user_id)
	end

	def self.find_thread_by_user(thread_id, user)
		return Website.where(:thread_id => thread_id, :user_id => user)
	end
end

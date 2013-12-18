class KaskusThread
	attr_accessor :thread_title, :thread_id, :created_date

	def initialize(thread_title, thread_id, created_date)
		@thread_title = thread_title
		@thread_id = thread_id
		@created_date = created_date
	end
end
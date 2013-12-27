class WelcomeController < ApplicationController
  
  def index
  	@websites_list = Website.where("content is not null").order(updated_at: :desc)
  end

end

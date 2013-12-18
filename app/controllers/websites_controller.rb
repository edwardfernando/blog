require 'nokogiri'
require 'open-uri'


class WebsitesController < ApplicationController

	before_action :is_logged_in,  except: [:show]
	before_action :is_kaskus_id_exits, only: [:kaskus_load_thread]

	def index
		@websites = Website.find_by_user(current_user.id)
		@website = Website.new
	end

	def new
		url = params[:website][:url]
		doc = Nokogiri::HTML(open(url))

		@website = Website.new
		@website.url = url
		@website.title = doc.css("h2.entry-title").text
		@website.content = doc.css("div.entry")[0].to_s
	end

	def create
		@website = Website.new(params[:website].permit(:url, :title, :content))
		@website.user = User.find(current_user.id)
		@website.save
		redirect_to @website
	end

	def show
		@website = Website.find(params[:id])
		@testimonials = @website.testimonials
	end

	def kaskus_new
		
	end

	def kaskus_create
		
	end
	
	def kaskus_load_thread
		kaskus_url = "http://www.kaskus.co.id/profile/viewallclassified/#{current_user.kaskus_id}"
		@doc = Nokogiri::HTML(open(kaskus_url))
		puts @doc
	end

	private 
	def is_kaskus_id_exits
		if current_user.kaskus_id.empty?
			flash[:warning] = "You haven't provided a kaskus ID"
			redirect_to kaskus_new_websites_path
		end
	end

end

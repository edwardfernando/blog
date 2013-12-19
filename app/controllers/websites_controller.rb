require 'nokogiri'
require 'open-uri'
require 'securerandom'


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
		@user = User.find(current_user.id)
	end

	def kaskus_create
		token = SecureRandom.urlsafe_base64(50)

		User.find(current_user.id).update(:kaskus_id => params[:user][:kaskus_id],:kaskus_auth_token => token)

		flash[:success] = "Kaskus ID saved successfully, your authentication token is #{token}"
		redirect_to kaskus_new_websites_path
	
	end
	
	def kaskus_load_thread
		kaskus_url = "http://www.kaskus.co.id/profile/viewallclassified/#{current_user.kaskus_id}"
		doc = Nokogiri::HTML(open(kaskus_url))
		
		@kaskus_threads = {}
		doc.css("table.zebra").css("tbody tr").each do |item|
			thread_id = item.css("a")[0]["href"].split("/")[2]
			@kaskus_threads[thread_id] = KaskusThread.new item.css(".post-title").text, thread_id , item.css("time").text
		end


	end

	private 
	def is_kaskus_id_exits
		if current_user.kaskus_id.blank?
			flash[:warning] = "You haven't provided a kaskus ID"
			redirect_to kaskus_new_websites_path
		end
	end

end

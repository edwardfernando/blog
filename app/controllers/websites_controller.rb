require 'nokogiri'
require 'open-uri'
require 'securerandom'


class WebsitesController < ApplicationController

	before_action :is_logged_in,  except: [:show]
	before_action :is_kaskus_id_exits, only: [:kaskus_fjb_thread_list, :kaskus_load_thread]
	before_action :is_kaskus_id_verified, only: [:kaskus_fjb_thread_list, :kaskus_load_thread]

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
		is_verify = current_user.kaskus_is_verify.to_s
		if is_verify == "true"
			flash[:success] = "Your Kaskus Token is already verified"
		end
	end

	def kaskus_create
		token = SecureRandom.urlsafe_base64(50)

		User.find(current_user.id).update(:kaskus_id => params[:user][:kaskus_id],:kaskus_auth_token => token)

		flash[:success] = "Kaskus ID saved successfully, your authentication token is #{token}"
		redirect_to kaskus_new_websites_path
	
	end
	
	def kaskus_fjb_thread_list
		@websites = current_user.websites
	end

	def kaskus_load_thread
		kaskus_url = "http://www.kaskus.co.id/profile/viewallclassified/#{current_user.kaskus_id}"
		doc = Nokogiri::HTML(open(kaskus_url))
		
		new_thread_count = 0
		doc.css("table.zebra").css("tbody tr").each do |item|
			thread_id = item.css("a")[0]["href"].split("/")[2]

			if Website.where(:thread_id => thread_id).blank?
				thread_title = item.css(".post-title").text
				thread_create_date = item.css("time").text
				thread_url = "http://www.kaskus.co.id/thread/#{thread_id}"

				Website.create(
					url:thread_url, 
					title:thread_title, 
					thread_create_date:thread_create_date,
					thread_id:thread_id,
					user:current_user).save

				new_thread_count += 1
			end
		end

		if new_thread_count > 0
			flash[:success] = "#{new_thread_count} thread(s) successfully loaded to your list"
		end

		redirect_to kaskus_fjb_thread_list_websites_path
	end

	def kaskus_init_thread

	end

	def kaskus_verify_token
		is_verify = current_user.kaskus_is_verify.to_s
		puts "current status : "+is_verify
		if is_verify == "false"
			user_obj = User.find(current_user.id)
			kaskus_id = user_obj.kaskus_id
			kaskus_auth_token = user_obj.kaskus_auth_token

			kaskus_profile_url = "http://www.kaskus.co.id/profile/#{kaskus_id}"
			
			doc = Nokogiri::HTML(open(kaskus_profile_url))

			kaskus_bio = doc.css("div.description").text.delete(" ")
			bio_token = kaskus_bio[3, kaskus_bio.length - 3]

			@auth_status = false
			if kaskus_auth_token == bio_token
				user_obj.kaskus_is_verify = 1
				user_obj.kaskus_verify_date = Time.now
				user_obj.save
				
				@auth_status = true
				flash[:success] = "Thanks, Your token has been verified"
				redirect_to kaskus_new_websites_path
			else
				flash[:warning] = "Verification failed! Please update your bio with following token"
				redirect_to kaskus_new_websites_path
			end

		else
			flash[:success] = "Your token has been verified"
		end
	end

	private 
	def is_kaskus_id_exits
		if current_user.kaskus_id.blank?
			flash[:warning] = "You haven't provided a kaskus ID"
			redirect_to kaskus_new_websites_path
		end
	end

	def is_kaskus_id_verified
		if !current_user.kaskus_is_verify
			flash[:warning] = "Your kaskus account is not verified. You need to add the following token into your kaskus's bio' coloum, and click 'Verify My Account' link below"
			redirect_to kaskus_new_websites_path
		end
	end

end

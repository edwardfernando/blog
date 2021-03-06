require 'nokogiri'
require 'open-uri'
require 'securerandom'


class WebsitesController < ApplicationController

	before_action :is_logged_in,  except: [:show]
	before_action :is_kaskus_id_exits, only: [:kaskus_fjb_thread_list, :kaskus_load_thread]
	before_action :is_kaskus_id_verified, only: [:kaskus_fjb_thread_list, :kaskus_load_thread]

	def index
		# @websites = Website.find_by_user(current_user.id)
		# @website = Website.new
	end

	def show
		@website = Website.where(:thread_id => params[:id]).first
		@testimonials = Testimonial.where(:website => @website).order(created_at: :desc)
	end

	def kaskus_new
		# @user = User.find(current_user.id)
	end

	def kaskus_create
		@user = current_user
		kaskus_id_param = params[:user][:kaskus_id]

		@user.kaskus_id = kaskus_id_param

		if @user.kaskus_id.blank?
			flash[:warning] = "Your kaskus ID is blank. Please input your kaskus ID"
		else
			token = SecureRandom.urlsafe_base64(25)
			User.find(current_user.id).update(:kaskus_id => kaskus_id_param, :kaskus_auth_token => token, :kaskus_is_verify => false)
			flash[:success] = "Kaskus ID saved successfully"
		end
	
		redirect_to profiles_path
	end
	
	def kaskus_fjb_thread_list
		is_kaskus_id_verified
		@websites = current_user.websites
	end

	def kaskus_load_thread
		kaskus_url = "http://www.kaskus.co.id/profile/viewallclassified/#{current_user.kaskus_id}"
		doc = Nokogiri::HTML(open(kaskus_url))
		
		new_thread_count = 0
		doc.css("table.zebra").css("tbody tr").each do |item|
			thread_id = item.css("a")[0]["href"].split("/")[2]

			if Website.find_thread_by_user(thread_id, current_user).blank?
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
		else
			flash[:success] = "No new thread found"
		end
			

		redirect_to kaskus_fjb_thread_list_websites_path
	end

	def kaskus_init_thread
		website = Website.find_thread_by_user(params[:id], current_user).first

		if website.content.blank?
			doc = Nokogiri::HTML(open(website.url))
			website.content = doc.css("div.entry")[0].to_s
			website.save!

			flash[:success] = "New thread initialized"
		end

		redirect_to website_path(website.thread_id)
	end

	def kaskus_verify_token
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
			flash[:success] = "Thanks, Your kaskus account has been verified"
			redirect_to kaskus_fjb_thread_list_websites_path
		else
			flash[:warning] = "Verification failed! Please update your bio with following token"
			redirect_to profiles_path
		end
	end

	private 
	def is_kaskus_id_exits
		if current_user.kaskus_id.blank?
			flash[:warning] = "You haven't provided a kaskus ID"
			redirect_to profiles_path
		end
	end

	def is_kaskus_id_verified
		if !current_user.kaskus_is_verify
			flash[:warning] = "Your kaskus account is not verified."
			redirect_to profiles_path
		end
	end

end

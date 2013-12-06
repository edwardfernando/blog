require 'nokogiri'
require 'open-uri'


class WebsitesController < ApplicationController

	def index
		@websites = Website.all
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
		@website.save
		redirect_to @website
	end

	def show
		@website = Website.find(params[:id])
	end

end

require 'httparty'
require 'json'

class ApplicationController < ActionController::Base
	before_action :repo_info, only: [:index, :show, :edit, :new]
	def repo_info
		response = HTTParty.get('https://api.github.com/repos/sueboyd922/little-esty-shop/contributors')
		body = JSON.parse(response.body, symbolize_names: true)
		if body[:message]
			@repo_info = body[:message]
		else
			repo_info = body 
		end
	end

end

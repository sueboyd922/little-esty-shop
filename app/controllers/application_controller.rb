require 'httparty'
require 'json'

class ApplicationController < ActionController::Base
	before_action :repo_info, only: [:index, :show, :edit, :new]
	def repo_info
		response = HTTParty.get('https://api.github.com/repos/sueboyd922/little-esty-shop/contributors')
		@repo_info = JSON.parse(response.body, symbolize_names: true)
	end

end

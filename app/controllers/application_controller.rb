class ApplicationController < ActionController::Base
	before_action :repo_info, only: [:index, :show, :edit, :new]
	
	def repo_info
		@contributors = GithubSearch.new.output
	end

end

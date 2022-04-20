require_relative '../services/github_service.rb'
require_relative '../poros/contributor.rb'


class GithubSearch
	def output
		json_info = GithubService.new.contributors
		json_info.class != Hash ? contributor_information : json_info[:message]
	end

	def contributor_information
		service.contributors.map do |data|
			Contributor.new(data)
		end
	end

	def service
		GithubService.new
	end
end
require 'rails_helper'

RSpec.describe GithubSearch do 
	describe '.contributor_information' do 
		it 'create contributor poros' do 
			contributors = GithubSearch.new.contributor_information
			expect(contributors.first).to be_a Contributor 
		end
	end
end
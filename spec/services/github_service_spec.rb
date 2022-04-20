require 'rails_helper'

RSpec.describe GithubService do 
	describe '.get(url) and contributors' do 
		it 'gets and parses url into a hash' do 
			contributors_url = GithubService.new.get_url('https://api.github.com/repos/sueboyd922/little-esty-shop/contributors')
			expect(contributors_url).to be_an Array 
			expect(contributors_url.first[:login].nil?).to be false
		end
	end
end
require 'rails_helper'


RSpec.describe Contributor do 
	it 'exists and has user_name and contributions' do 
		data = {login: 'kg-byte', contributions: 50}
		contributor = Contributor.new(data)
		expect(contributor).to be_a Contributor
		expect(contributor.user_name).to eq'kg-byte'
		expect(contributor.contributions).to eq 50
	end


end
require "rails_helper"

RSpec.describe "the admin merchants edit page" do
  it "edits an existing merchant" do
    visit edit_admin_merchant_path

    fill_in 'Name', with: 'Something new'
    click_button 'Submit'
    
    expect(page).to have_content("Welcome to Admin Dashboard")
  end


  end
end

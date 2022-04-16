require "rails_helper"

RSpec.describe "the admin merchants indexpage" do
  it "lists all merchants name in the system" do
    FactoryBot.create_list(:merchant, 5)

    visit admin_merchants_path
    Merchant.all.each do |merchant|
      expect(page).to have_content(merchant.name)
    end
  end
end
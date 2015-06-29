require_relative 'acceptance_helper'

feature 'User can sign out', %q{
  In order to secure leave community
  As an user
  I want to sign out
} do

  given(:user) { create :user }

  scenario 'User logout' do
    sign_in(user)
    click_on "Logout"

    expect(page).to have_content("Signed out successfully.")
  end

end
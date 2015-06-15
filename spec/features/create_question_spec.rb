require 'rails_helper'

feature "Create question", %q{
  In order to get answer from community
  As an authenticate User,
  I want to be able to ask questions.
} do

  given(:user) { create :user }

  scenario "Authenticated User creates question" do

    sign_in(user)

    visit questions_path
    click_on "Ask question"
    fill_in "Title", with: "Test Question"
    fill_in "Body", with: "Test Body"
    click_on "Submit"

    expect(page).to have_content("Successfully created question.")
    expect(page).to have_content("Test Question")
    expect(page).to have_content("Test Body")
  end

  scenario "Non-authenticated User creates question" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

end
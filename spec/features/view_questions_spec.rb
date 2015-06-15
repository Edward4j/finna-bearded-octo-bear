require 'rails_helper'

feature 'View questions', %q{
  In order to get information from community
  As an user
  I want to be able view list of questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario "User can see questions" do
    visit questions_path

    questions.each do |question|
      expect(page).to have_link(question.title)
    end
  end
end
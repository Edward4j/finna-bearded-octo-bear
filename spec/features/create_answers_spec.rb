require_relative 'acceptance_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated user,
  I want to be able to create answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'My Answer'
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content('My Answer')
    end
  end

end
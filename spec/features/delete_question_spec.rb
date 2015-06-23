require 'rails_helper'

feature 'delete question', %q{
  In order to remove question
  As an author
  I want to delete question
} do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'authenticated user can delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content "Your question successfully deleted."
    expect(page).to_not have_content(question.title)
  end

  scenario 'unauthenticated can not delete question not belonging to him' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'authenticated user can not delete question not belonging to him' do
    sign_in(user1)
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end
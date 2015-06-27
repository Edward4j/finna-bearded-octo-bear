require 'rails_helper'

feature 'delete answer', %q{
  In order to remove my answer
  As an author
  I want to delete answer
} do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }
  given!(:answer) { create(:answer, user: user) }

  scenario 'authenticated user can delete his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)
    save_and_open_page
    click_on 'Delete answer'

    expect(page).to_not have_content(answer.body)
  end

  scenario 'unauthenticated can not delete answer not belonging to him' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'authenticated user can not delete answer not belonging to him' do
    sign_in(user1)
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end
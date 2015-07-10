require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like ot be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link to Edit question' do
      within '.question_ui' do
        expect(page).to have_link 'Edit question'
      end
    end

    scenario 'try to edit his question', js: true do
      click_on 'Edit question'

      fill_in 'question_title', with: 'Edited question title'
      fill_in 'question_body', with: 'Edited question body'
      click_on 'Save'
      question.reload

      within '.question_ui' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to_not have_selector 'textfield'
      end
      expect(page).to have_content 'Edited question title'
      expect(page).to have_content 'Edited question body'
    end

    scenario 'try to edit not his question', js: true do
      visit question_path(question2)
      expect(page).to_not have_content 'Edit question'
    end
  end
end
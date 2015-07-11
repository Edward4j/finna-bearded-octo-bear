require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  In order to remove files, attached to answer
  As an answer's author,
  I want to be able to delete files from answer
} do

  given!(:owner) { create(:user) }
  given!(:question) { create(:question, user: owner) }
  given!(:answer) { create(:answer, question: question, user: owner) }
  given!(:attachment) { create(:attachment, attachable: answer)}
  given!(:non_owner) { create(:user) }

  describe 'User delete file by answer', js: true do
    background do
      sign_in(owner)
      visit question_path(question)
    end

    scenario "sees link to delete attachment" do
      within ".answers" do
        expect(page).to have_link "Delete attachment"
        expect(page).to have_link(attachment.file.identifier)
      end
    end

    scenario "delete attachment" do
      within ".answers" do
        click_on "Delete attachment"
      end

      expect(page).to_not have_link(attachment.file.identifier)
    end
  end

  scenario 'Authenticated non-owner tries to delete file by answer' do
    sign_in(non_owner)
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_link "Delete attachment"
    end
  end

  scenario 'Non-authenticated non-owner tries to delete file by answer' do
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_link "Delete attachment"
    end
  end
end
require_relative 'acceptance_helper'

feature 'Delete files from question', %q{
  In order to remove files, attached to question
  As an question's author,
  I want to be able to delete files from question
} do

  given!(:owner) { create(:user) }
  given!(:question) { create(:question, user: owner) }
  given!(:attachment) { create(:attachment, attachable: question)}
  given!(:non_owner) { create(:user) }

  describe 'User delete file by question', js: true do
    background do
      sign_in(owner)
      visit question_path(question)
    end

    scenario "sees link to delete attachment" do
      expect(page).to have_link "Delete attachment"
      expect(page).to have_link(attachment.file.identifier)

      click_on "Delete attachment"

      expect(page).to_not have_link(attachment.file.identifier)
    end
  end

  scenario 'Authenticated non-owner tries to delete file by question' do
    sign_in(non_owner)
    visit question_path(question)

    expect(page).to_not have_link "Delete attachment"
    expect(page).to_not have_link(attachment.file.identifier)
  end

  scenario 'Non-authenticated non-owner tries to delete file by question' do
    visit question_path(question)

    expect(page).to_not have_link "Delete attachment"
  end
end
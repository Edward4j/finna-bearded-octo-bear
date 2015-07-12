require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author,
  I want to be able to attach files to question
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    #visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    click_on "Ask question"
    fill_in "Title", with: "Test Question"
    fill_in "Body", with: "Test Body"
    attach_file 'File', "#{Rails.root}/spec/fixtures/files/spec_helper.rb"
    click_on "Submit"

    expect(page).to have_link('spec_helper.rb'), href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds files when asks question', js: true do
    click_on "Ask question"
    fill_in "Title", with: "Test Question"
    fill_in "Body", with: "Test Body"

    click_on 'add attachment'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/fixtures/files/1.txt")
    inputs[1].set("#{Rails.root}/spec/fixtures/files/1copy.txt")
    click_on "Submit"

    expect(page).to have_link('1.txt'), href: '/uploads/attachment/file/1/1.txt'
    expect(page).to have_link('1copy.txt'), href: '/uploads/attachment/file/2/1copy.txt'
  end
end
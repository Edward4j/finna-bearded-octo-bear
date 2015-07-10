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

  scenario 'User adds files when asks question' do
    click_on "Ask question"
    fill_in "Title", with: "Test Question"
    fill_in "Body", with: "Test Body"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on "Submit"

    expect(page).to have_link('spec_helper.rb'), href: '/uploads/attachment/file/1/spec_helper.rb'

  end
end
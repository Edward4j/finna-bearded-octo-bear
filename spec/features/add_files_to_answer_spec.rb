require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate answer
  As an answer's author
  I'd like to attach files to answer
  } do

  given(:user) { create(:user) }
  given(:question) { create(:question)}

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when creates answer', js: true do
    fill_in 'Your answer', with: 'Some Answer body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link('spec_helper.rb'), href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds files when creates answer', js: true do
    fill_in 'Your answer', with: 'Some Answer body'

    click_on 'add attachment'

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/public/uploads/attachment/file/8/1.txt")
    inputs[1].set("#{Rails.root}/public/uploads/attachment/file/11/1copy.txt")
    click_on 'Create answer'

    expect(page).to have_link('1.txt'), href: '/uploads/attachment/file/8/1.txt'
    expect(page).to have_link('1copy.txt'), href: '/uploads/attachment/file/11/1copy.txt'
  end
end
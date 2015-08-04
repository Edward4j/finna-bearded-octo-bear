require_relative "acceptance_helper"

feature 'Create comment', %q{
  in order to clarify and specify question
  or immerse deeper in questions problem
  as an authenticated user
  i want to able create comment
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'authenticated user creates comment', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'add a comment'
    fill_in "comment[body]", with: 'Test content'
    click_on 'Add Comment'

    #expect(page).to have_content "Your comment successfully created."
    expect(page).to have_content 'Test content'
  end

  scenario 'comment with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'add a comment'
    fill_in 'Your Comment', with: ''
    click_on 'Add Comment'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'unautenticated user tries to create question' do
    visit question_path(question)

    expect(page).to_not have_link "add a comment"
  end
end
require_relative "acceptance_helper"

feature 'Create comment', %q{
  in order to clarify and specify answer
  or immerse deeper in answers problem
  as an authenticated user
  i want to able create comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'authenticated user creates a comment to answer', js: true do
    sign_in(user)
    visit question_path(question)
    within(".answer_#{answer.id}") do
      click_on 'add a comment'
      fill_in 'comment[body]', with: 'Test content'
      click_on 'Add Comment'
    end

    #expect(page).to have_content "Your comment successfully created."
    expect(page).to have_content 'Test content'
  end

  scenario "invalid answer's comment", js: true do
    sign_in(user)
    visit question_path(question)
    within(".answer_#{answer.id}") do
      click_on 'add a comment'
      fill_in 'comment[body]', with: ''
      click_on 'Add Comment'
    end

    expect(page).to have_content "body can't be blank"
  end


  scenario 'unautenticated user tries to create comment to answer' do
    visit question_path(question)

    within(".answer_#{answer.id}") do
      expect(page).to_not have_link "add a comment"
    end
  end
end
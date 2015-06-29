require_relative 'acceptance_helper'

feature 'Create Answer', %q{
  In order to answer to question
  As an registered user,
  I want to be able create answer
} do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer1) { create :answer, question: question, user: user }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer[body]', with: 'Some Answer body'
    click_on 'Create answer'

    expect(page).to have_content('Some Answer body')
    expect(page).to have_content(answer1.body)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(current_path).to eq(question_path(question))
  end

  scenario 'Authenticated user creates wrong answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Create answer'
    expect(page).to have_content("Body can't be blank")
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)

    fill_in 'answer[body]', with: 'Some Answer'
    click_on 'Create answer'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_content('Login')
  end

end
require_relative 'acceptance_helper'

feature 'View Question and their answers', %q{
  In order to find answers to the question
  As an user
  I want to see all the answers to the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }

  scenario "User can see question and related answers" do
    visit question_path(question)

    question.answers.each do |qa|
      expect(page).to have_content(qa.body)
    end
  end

end
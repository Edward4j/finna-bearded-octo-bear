require 'features/acceptance_helper'

feature "Vote for question", %q{
  In order to like or dislike question
  As an user
  I want to be able vote for question
  } do

  describe "Authenticated user" do
    let(:user) { create(:user) }

    describe "owner question" do
      let(:question) { create(:question, user: user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario "vote for question" do
        expect(page).to_not have_link "Like"
        expect(page).to_not have_link "Dislike"
      end
    end

    describe "non-owner question" do
      let(:question) { create(:question) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      describe "like" do
        scenario "see link to vote for question" do
          within ".question_#{question.id}" do
            expect(page).to have_link "Like"
          end
        end

        scenario "vote for question", js: true do
          within ".question_#{question.id}" do
            click_on "Like"

            expect(page).to_not have_link "Like"
            expect(page).to_not have_link "Disike"
            expect(page).to have_content "1"
            expect(page).to have_link "Cancel"
          end
        end
      end
    end

  end
end
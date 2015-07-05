require_relative "acceptance_helper"

feature "Author choose best answer", %q{
  In order to select best solution
  As an author of question
  I want to be able set the best answer
  } do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:best_answer) { create(:answer, question: question, user: user, best: true) }
  given!(:other_answer) { create(:answer, question: question) }
  given!(:non_owner) { create(:user) }

  describe "Owner of question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "sees link to select best answer" do
      expect(page).to have_link('Select Best')
    end
    scenario "Author of question sets best answer", js: true do
      within ".answer_#{answer.id}" do
        click_link('Select Best')
        expect(page).to have_link('Undo best answer')
      end
    end
    scenario "sees link to unselect best answer", js: true do
      within ".answer_#{best_answer.id}" do
        expect(page).to have_link('Undo best answer')
      end
    end
    scenario "unselect best answer", js: true do
      within ".answer_#{best_answer.id}" do
        click_link('Undo best answer')
        expect(page).to have_link('Select Best')
      end
    end
    scenario "select only one best answer", js: true do
      within ".answer_#{answer.id}" do
        click_link('Select Best')
      end
      within ".answer_#{best_answer.id}" do
        click_link('Select Best')
      end

      within ".answer_#{answer.id}" do
        expect(page).to have_link('Select Best')
      end
      within ".answer_#{best_answer.id}" do
        expect(page).to have_link('Undo best answer')
      end
    end

    scenario "sorting answers" do
      within "div.answer:nth-of-type(1)" do
        expect(page).to have_content best_answer.body
      end
      within "div.answer:nth-of-type(2)" do
        expect(page).to have_content answer.body
      end
      within "div.answer:nth-of-type(3)" do
        expect(page).to have_content other_answer.body
      end
    end
  end

  describe "Non-owner of answer" do
    before do
      sign_in(non_owner)
      visit question_path(question)
    end

    scenario "tries to select best answer" do
      expect(page).to_not have_link('Select Best')
    end

    scenario "tries to unselect best", js: true do
      within ".answer_#{answer.id}" do
        expect(page).to_not have_link('Select Best')
      end
      within ".answer_#{best_answer.id}" do
        expect(page).to_not have_content('Undo best answer')
      end
    end
  end


end
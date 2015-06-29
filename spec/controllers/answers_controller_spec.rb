require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question,
                 answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      it 'assigns answer to current user with question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        answer = assigns(:answer)
        expect(answer.user_id).to eq user.id
        expect(answer.question_id).to eq question.id
      end
      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template 'answers/create'#redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not saves the new answer in the database' do
        expect { post :create, question_id: question,
                      answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 'renders create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

end

require 'rails_helper'

describe AnswersController do
  let!(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:votable) { create(described_class.controller_name.singularize.underscore, question: question, user: user) }
  let(:vote) { create(:vote, votable: votable, user: user2) }

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
      # it 'render create template' do
      #   post :create, question_id: question, answer: attributes_for(:answer), format: :js
      #   expect(response).to render_template 'answers/create'
      # end
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

  describe 'PATCH #update' do

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns to question' do
      patch :update, id: answer, question_id: question, answer: { body: "new answer body"}, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: "new answer body"}, format: :js
      answer.reload
      expect(answer.body).to eq "new answer body"
    end

    it 'render update template to the updated answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end

  describe "DELETE #destroy" do
    context "owner delete answer" do

      it "delete answer" do
        expect{ delete :destroy, question_id: question, id: answer, format: :js }.to change(question.answers, :count).by(-1)
      end

      it "render destroy template" do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "non-owner delete answer" do
      let!(:question) { create(:question) }
      let!(:owner) { create(:user) }
      let!(:answer) { create(:answer, question: question, user: owner) }
      before { answer }
      sign_in_user

      it "does not delete question" do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe "POST #best" do
    context "onwer select best answer" do
      let!(:owner) { create(:user) }
      let!(:question) { create(:question, user: owner) }
      let!(:answer) { create(:answer, question: question) }

      before do
        sign_in(owner)
        post :best, question_id: question, id: answer, format: :js
      end

      it "best answer" do
        expect(answer.reload.best).to be_truthy
      end
    end

    context "non-onwer select best answer" do
      let!(:owner) { create(:user) }
      let!(:non_owner) { create(:user) }
      let!(:question) { create(:question, user: owner) }
      let!(:answer) { create(:answer, question: question) }

      before do
        sign_in(non_owner)
        post :best, question_id: question, id: answer, format: :js
      end

      it "answer is not selected as best" do
        expect(answer.reload.best).to be false
      end
    end

  end

  describe "POST #cancel_best" do
    context "onwer cancel best answer" do
      sign_in_user
      let!(:question) { create(:question, user: user) }
      let!(:best_answer) { create(:answer, question: question, best: true) }

      before { post :cancel_best, question_id: question, id: answer, format: :js }

      it "cancel best answer" do
        expect(answer.reload.best).to be false
      end
    end

    context "non-onwer cancel best answer" do
      let!(:owner) { create(:user) }
      let!(:non_owner) { create(:user) }
      let!(:question) { create(:question, user: owner) }
      let!(:answer) { create(:answer, question: question, best: true) }

      it "best answer is not cancelled" do
        sign_in(non_owner)

        expect { post :cancel_best, question_id: question, id: answer, format: :js }.not_to change { answer.reload.best }
      end
    end
  end

  describe 'POST #vote_up' do
    before { sign_in(user2) }
    context 'non-owner of answer' do
      it 'changes the vote, score 1' do
        expect { post :vote_up, id: answer, format: :json }.to change(Vote, :count).by(1)
      end
    end
  end
  describe 'POST #vote_down' do
    before { sign_in(user2) }
    context 'non-owner of answer' do
      it 'changes the vote, score -1' do
        expect { post :vote_down, id: answer, format: :json }.to change(Vote, :count).by(1)
      end
    end
  end
  describe 'DELETE #cancel_vote' do
    before { sign_in(user2) }
    before { vote }
    context 'non-owner of answer' do
      it 'cancels the vote' do
        expect { delete :cancel_vote, id: votable, format: :json }.to change(Vote, :count).by(-1)
      end
    end
  end

end

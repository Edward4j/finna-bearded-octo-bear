require 'rails_helper'

describe CommentsController do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid atrributes for question' do
      it 'saves new comment with question_id' do
        expect { post :create,
          question_id: question,
          commentable: 'questions',
          comment: attributes_for(:comment),
          format: :js
        }.to change(Comment, :count).by(1)
      end

      it 'assigns comment to question_id' do
        post :create, question_id: question, commentable: 'questions',
          comment: attributes_for(:comment), format: :js

        comment = assigns(:comment)
        expect(comment.user_id).to eq user.id
        expect(comment.commentable_id).to eq question.id
      end

      it 'redirects to show @question' do
        post :create, question_id: question, commentable: 'questions',
          comment: attributes_for(:comment), format: :json

        expect(response).to be_success
      end
    end

    context 'with invalid attributes for question' do
      it 'does not save comment' do
        expect { post :create,
          question_id: question,
          commentable: 'questions',
          comment: attributes_for(:comment, :invalid),
          format: :js
        }.to_not change(Comment, :count)
      end

      it 'return 422 status' do
        post :create, question_id: question, commentable: 'questions',
          comment: attributes_for(:comment, :invalid), format: :json

        expect(response.status).to eq 422
      end
    end

    context 'with valid atrributes for answer' do
      it 'saves new comment with answer_id' do
        expect { post :create,
          answer_id: answer,
          commentable: 'answers',
          comment: attributes_for(:comment),
          format: :js
        }.to change(Comment, :count).by(1)
      end

      it 'assigns comment to answer_id' do
        post :create, answer_id: answer, commentable: 'answers',
          comment: attributes_for(:comment), format: :js

        comment = assigns(:comment)
        expect(comment.user_id).to eq user.id
        expect(comment.commentable_id).to eq answer.id
      end

      it 'redirects to show @question' do
        post :create, answer_id: answer, commentable: 'answers',
          comment: attributes_for(:comment), format: :json

        expect(response).to be_success
      end
    end

    context 'with invalid attributes for answer' do
      it 'does not save comment' do
        expect { post :create,
          answer_id: answer,
          commentable: 'answers',
          comment: attributes_for(:comment, :invalid),
          format: :js
        }.to_not change(Comment, :count)
      end

      it 'returns error status' do
        post :create, answer_id: answer, commentable: 'answers',
          comment: attributes_for(:comment, :invalid), format: :json

        expect(response).to_not be_success
      end
    end
  end
end
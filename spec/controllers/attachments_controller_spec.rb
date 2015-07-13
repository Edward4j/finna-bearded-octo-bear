require 'rails_helper'

describe AttachmentsController do
  describe 'DELETE #destroy' do
    describe 'question' do
      context 'owner delete attachment' do
        let!(:user) { create(:user) }
        let!(:question) { create(:question, user: user) }
        let!(:attachment) { create(:attachment, attachable: question) }

        before { sign_in(user) }

        it 'delete attachment' do
          expect{ delete :destroy, question_id: question, id: attachment, format: :js }.to change(question.attachments, :count).by(-1)
        end
      end

      context 'non-owner delete attachment' do
        let!(:user) { create(:user) }
        let!(:owner) { create(:user) }
        let!(:question) { create(:question, user: owner) }
        let!(:attachment) { create(:attachment, attachable: question) }

        before { sign_in(user) }

        it 'delete attachment' do
          expect{ delete :destroy, question_id: question, id: attachment, format: :js }.to_not change(Attachment, :count)
        end
      end
    end

    describe 'answer' do
      context 'owner delete attachment' do
        let!(:user) { create(:user) }
        let!(:question) { create(:question, user: user) }
        let!(:answer) { create(:answer, question: question, user: user) }
        let!(:attachment) { create(:attachment, attachable: answer) }

        before { sign_in(user) }

        it 'delete attachment' do
          expect(answer.attachments.count).to eq 1
          expect{ delete :destroy, question_id: question, answer_id: answer, id: attachment, format: :js }.to change(Attachment, :count).by(-1)
        end
      end

      context 'non-owner delete attachment' do
        let!(:user) { create(:user) }
        let!(:owner) { create(:user) }
        let!(:question) { create(:question, user: owner) }
        let!(:answer) { create(:answer, question: question) }
        let!(:attachment) { create(:attachment, attachable: answer) }

        before { sign_in(user) }

        it 'delete attachment' do
          expect{ delete :destroy, question_id: question, answer_id: answer, id: attachment, format: :js }.to_not change(Attachment, :count)
        end
      end
    end
  end
end

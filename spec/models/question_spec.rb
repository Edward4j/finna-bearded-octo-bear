require 'rails_helper'

RSpec.describe Question, type: :model do

  describe "validations" do
    it { should validate_presence_of :title}
    it { should validate_presence_of :body}
    it { should validate_presence_of :user_id}

    it { should accept_nested_attributes_for :attachments}
  end
  describe "assotiations" do
    it { should have_many(:answers).dependent(:destroy)}
    it { should have_many(:attachments).dependent(:destroy) }
    it { expect(subject).to belong_to(:user) }
  end

  describe "by removing question answers removing too" do
    let(:question) { create(:question)}
    let(:answer) { create_list(:answer, 2)}

    it "removes answers" do
      question.answers << answer
      expect { question.destroy }.to change{ Answer.count }.by(-2)
    end
  end

end

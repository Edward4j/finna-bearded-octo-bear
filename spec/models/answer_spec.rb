require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe "validations" do
    it { should validate_presence_of :user_id}
    it { should validate_presence_of :body}
    it { should validate_presence_of :question_id}
  end
  describe "assotiations" do
    it { expect(subject).to belong_to(:question) }
    it { expect(subject).to belong_to(:user) }
  end

  describe "#select best" do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it "answer select_best" do
      answer.select_best
      expect(answer.reload.best).to be_truthy
    end

    it "false other answer" do
      other_answer = create(:answer, question: question, best: true)
      answer.select_best
      expect(other_answer.reload.best).to be false
    end
  end

  it "#cancel best" do
    answer = create(:answer, best: true)
    answer.cancel_best
    expect(answer.best).to be false
  end
end

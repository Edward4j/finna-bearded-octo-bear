require 'rails_helper'

RSpec.describe Question, type: :model do

  describe "validations" do
    it { should validate_presence_of :title}
    it { should validate_presence_of :body}
  end
  describe "assotiations" do
    it { should have_many(:answers).dependent(:destroy)}
  end

  describe "by removing question answers removing too" do
    question1 = FactoryGirl.create(:question, title: "Fox say", body: "What does the fox say?")
    answer1 = FactoryGirl.create(:answer, body: "Mimimi")
    answer2 = FactoryGirl.create(:answer, body: "Yaaaaa!")
    question1.answers << answer1
    question1.answers << answer2
    it { expect { question1.destroy }.to change{ Answer.count }.by(-2) }
  end

end

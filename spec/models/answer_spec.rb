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
end

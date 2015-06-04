require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe "validations" do
    it { should validate_presence_of :body}
    it { should validate_presence_of :question}
  end
  describe "assotiations" do
    it { expect(subject).to belong_to(:question) }
  end
end

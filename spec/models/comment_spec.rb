require 'rails_helper'

describe Comment do
  describe "validations" do
    it { should validate_presence_of :body}
    it { should validate_presence_of :commentable }
    it { should validate_presence_of :user }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }
  end
end
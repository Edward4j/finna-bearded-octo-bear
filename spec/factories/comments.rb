FactoryGirl.define do
  factory :comment do
    body "My Comment"
    association :user
    association :commentable, factory: :question
  end
end
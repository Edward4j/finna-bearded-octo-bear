FactoryGirl.define do
  factory :comment do
    body "My Comment"
    association :user
    association :commentable, factory: :question

    trait :invalid do
      body nil
    end
  end
end
FactoryGirl.define do
  factory :answer do
    association :user
    association :question
    title "Answer MyTitle"
    body "Answer MyText"
  end

  factory :invalid_answer, class: Answer do
    body nil
  end

end

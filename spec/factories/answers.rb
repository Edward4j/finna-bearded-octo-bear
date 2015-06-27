FactoryGirl.define do
  factory :answer do
    user
    question
    body "Answer MyText"
  end

  factory :invalid_answer, class: Answer do
    body nil
  end

end

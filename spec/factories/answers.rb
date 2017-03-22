FactoryGirl.define do
  factory :answer do
    code "q1.1"
    question_id 1
    text "Yes, we have published at least one dataset under an open licence"
    notes ""
    positive true
  end

  factory :negative_answer, class: Answer do
    code "q1.2"
    question_id 1
    text "No, we have not yet published any open data"
    notes ""
    positive false
    score 1
  end

  factory :answer3, class: Answer do
    code "q1.2"
    question_id 1
    text "No, we have not yet published any open data"
    notes ""
    positive false
    score 1
  end

  factory :answer4, class: Answer do
    code "q1.2"
    question_id 1
    text "No, we have not yet published any open data"
    notes ""
    positive true
    score 1
  end

end

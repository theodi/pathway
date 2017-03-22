FactoryGirl.define do

  factory :assessment_answer do
    question_id 1
    answer
    assessment_id 1
    notes "MyText"
  end

  factory :assessment_answer2, class: AssessmentAnswer do
    question_id 1
    association :answer, factory: :negative_answer
    assessment_id 1
    notes "MyText"
  end

end

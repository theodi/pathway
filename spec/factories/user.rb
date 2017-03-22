  FactoryGirl.define do

  sequence :email do |n|
    "org#{n}@example.com"
  end

  sequence :organisation_id, 0 do |n|
    n % 6 + 1
  end

  factory :user do
    name "Peter Manion"
    email "user@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
  end

  factory :country_user, class: User do
    name "Mike Manion"
    email "org2@example.org"
    password 'somepassword'
    country_id 14
    association :country, factory: :country2
    encrypted_password Devise.bcrypt(User, 'somepassword')
  end

  factory :country_user2, class: User do
    name "Paul Manion"
    email "user9@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
    country_id 234
    association :country, factory: :country4
  end

  factory :country_organisation_user, class: User do
    name "Mary Manion"
    email
    password 'somepassword'
    organisation_id
    association :country, factory: :country3
    association :organisation, factory: :organisation8
    encrypted_password Devise.bcrypt(User, 'somepassword')
    factory :country_organisation_user_with_assessments do
      transient do
        assessment2s_count 5
      end
      after(:create) do |user, evaluator|
        assessmentList = create_list(:assessment2, evaluator.assessment2s_count, user: user)
        assessmentList.each do | assessment |
          AssessmentAnswer.create(assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
          assessment.complete
        end
      end
    end
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    name "James Manion"
    email "admin@example.org"
    password 'otherpassword'
    encrypted_password Devise.bcrypt(User, 'otherpassword')
    admin true
  end

  factory :organisation_user, class: User do
    name "John Manion"
    email
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
    association :organisation, factory: :organisation8
    factory :organisation_user_with_assessments do
      transient do
        assessments_count 3
      end
      after(:create) do |user, evaluator|
        assessmentList = create_list(:assessment3, evaluator.assessments_count, user: user)
        assessmentList.each_with_index do | assessment, index |
          AssessmentAnswer.create(assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
          assessment.complete if index != 0
        end
      end
    end
  end

  factory :organisation_user2, class: User do
    name "David Manion"
    email "org6@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
    organisation_id
  end

  factory :organisation_sequence_user, class: User do
    name "Jenny Manion"
    email
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
    association :organisation, factory: :organisation8
  end


end

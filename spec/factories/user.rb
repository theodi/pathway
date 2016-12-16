FactoryGirl.define do
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
    name "Peter Manion"
    email "user@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
    country_id 235
    association :country, factory: :country
  end

  factory :country_organisation_user, class: User do
    name "Mary Manion"
    email "org3@example.org"
    password 'somepassword'
    country_id 23
    organisation_id 8
    association :country, factory: :country3
    association :organisation, factory: :organisation2
    encrypted_password Devise.bcrypt(User, 'somepassword')
    factory :country_organisation_user_with_assessments do
      transient do
        assessment2s_count 5
      end
      after(:create) do |user, evaluator|
        create_list(:assessment2, evaluator.assessment2s_count, user: user)
      end
    end
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    name "Peter Manion"
    email "admin@example.org"
    password 'otherpassword'
    encrypted_password Devise.bcrypt(User, 'otherpassword')
    admin true
  end

  factory :organisation_user, class: User do
    name "Peter Manion"
    email "org@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
    organisation_id 1
  end

end

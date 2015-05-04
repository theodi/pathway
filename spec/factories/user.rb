FactoryGirl.define do
  factory :user do
    name "Peter Manion"
    email "user@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
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
FactoryGirl.define do
  factory :user do
    email "user@example.org"
    password 'somepassword'
    encrypted_password Devise.bcrypt(User, 'somepassword')
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    email "admin@example.org"
    password 'otherpassword'
    encrypted_password Devise.bcrypt(User, 'otherpassword')
    admin true
  end
end
Given(/^I am logged in as an administrator$/) do
  
  user =  FactoryGirl.create(:admin)
  @current_user = user

  visit '/users/sign_in'
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Sign in"
  
end

Given(/^I am logged in as a user$/) do
  
  user =  FactoryGirl.create(:user)
  @current_user = user
  
  visit '/users/sign_in'
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Sign in"
  
end

Given(/^there is a registered user$/) do
  FactoryGirl.create(:user)
end



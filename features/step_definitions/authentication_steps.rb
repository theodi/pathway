Given(/^I am logged in as an administrator$/) do
  
  user =  FactoryGirl.create(:admin)
  
  visit '/users/sign_in'
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Log in"
  
end

Given(/^I am logged in as a user$/) do
  
  user =  FactoryGirl.create(:user)
  
  visit '/users/sign_in'
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Log in"
  
end

Given(/^there is a registered user$/) do
  FactoryGirl.create(:user)
end



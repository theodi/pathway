When(/^I fill in Associated organisation with "([^"]*)"$/) do |value|
  hidden_field = find :xpath, "//input[@id='user_associated_organisation']"
  hidden_field.set value
end

Given(/^a user is already associated with "(.*?)"$/) do |org|
  user = FactoryGirl.build(:user)
  user.associated_organisation = org
  user.save
end
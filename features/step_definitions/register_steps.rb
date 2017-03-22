When(/^I fill in Associated organisation with "([^"]*)"$/) do |value|
  hidden_field = find :xpath, "//input[@id='user_associated_organisation']"
  hidden_field.set value
end

When(/^I fill in Associated country with "([^"]*)"$/) do |value|
  hidden_field = find :xpath, "//input[@id='user_associated_country']"
  user = FactoryGirl.build(:country)
  user.save
  hidden_field.set value
end

Given(/^a user is associated with an organisation named "(.*?)"$/) do |org|
  user = FactoryGirl.build(:user)
  user.associated_organisation = org
  user.save
end

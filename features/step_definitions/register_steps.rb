When(/^I fill in Associated organisation with "([^"]*)"$/) do |value|
  hidden_field = find :xpath, "//input[@id='user_associated_organisation']"
  hidden_field.set value
end

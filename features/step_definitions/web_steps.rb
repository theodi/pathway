When(/^I go to the homepage$/) do
  visit root_path
end

When(/^I go to the register page$/) do
  visit new_user_registration_path
end

When(/^I go to "(.*?)"$/) do |path|
  visit path
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, :with=>value
end

Then(/^I should see a link called "(.*?)" to "(.*?)"$/) do |link, url|
  page.should have_link(link, :href => url)
end

Then(/^I should be on the homepage$/) do |text|
  assert page.current_path == root_path
end

Then(/^I should see "(.*?)"$/) do |text|
  page.body.should include(text)
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.body.should_not include(text)
end

When(/^I click on "(.*?)"$/) do |link|
  click_link link
end

When(/^I press "(.*?)"$/) do |button|
  click_button(button)
end
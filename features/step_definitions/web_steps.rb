When(/^I go to the homepage$/) do
  visit root_path
end

Then(/^I should see a link called "(.*?)" to "(.*?)"$/) do |link, url|
  page.should have_link(link, :href => url)
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
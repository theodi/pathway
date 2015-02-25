When(/^I go to the homepage$/) do
  visit root_path
end

Then(/^I should see a link called "(.*?)" to "(.*?)"$/) do |link, url|
  page.should have_link(link, :href => url)
end


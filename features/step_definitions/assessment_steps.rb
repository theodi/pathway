Given(/^the following assessments:$/) do |table|
  table.hashes.each do |attributes|
    attributes.merge!(user_id: @current_user.id)
    FactoryGirl.create(:assessment, attributes)
  end
end

When(/^I delete an assessment$/) do
  all('.assessment')[0].first(:link, "Delete").click
end

Then(/^I should see "(.*?)" assessments$/) do |count|
  expect(page).to have_selector('.assessment', count: count)
end

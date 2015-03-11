Given(/^I have assessments$/) do
  current_user.assessments.create(FactoryGirl.attributes_for(:assessment))
  current_user.assessments.create(FactoryGirl.attributes_for(:unfinished_assessment))   
end

Given(/^the following assessments:$/) do |table|
  table.hashes.each do |attributes|
    attributes.merge!(user_id: @current_user.id)
    FactoryGirl.create(:assessment, attributes)
  end
end
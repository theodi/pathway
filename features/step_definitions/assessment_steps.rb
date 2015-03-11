Given(/^the following assessments:$/) do |table|
  table.hashes.each do |attributes|
    attributes.merge!(user_id: @current_user.id)
    FactoryGirl.create(:assessment, attributes)
  end
end
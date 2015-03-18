Given(/^the test survey has been loaded$/) do
  config = File.join( __dir__, "..", "..", "spec", "lib", "test-survey.xls" )    
  QuestionnaireImporter.load(1, config)    
end

Given(/^I have started an assessment$/) do
  @assessment = FactoryGirl.create(:unfinished_assessment, user_id: @current_user.id)
  dimension = FactoryGirl.create(:dimension)
  @activity = dimension.activities.create(FactoryGirl.attributes_for(:activity))
  @first_question = @activity.questions.create(FactoryGirl.attributes_for(:question))
  @activity.questions.create(FactoryGirl.attributes_for(:question, code: "q2", text: "Have you released an open data schedule?"))
  @activity.questions.create(FactoryGirl.attributes_for(:question, code: "q3", text: "Do you have an open data officer?"))
  
  @positive = FactoryGirl.create(:answer)
  @negative = FactoryGirl.create(:negative_answer)
end

When(/^I go to the first question$/) do
  visit assessment_question_path(@assessment, @activity.questions.first)
end

When(/^I go back to the first question$/) do
  visit assessment_edit_answer_path(@assessment, @assessment.assessment_answers.first)
end

Given(/^I have answered the first question including a link$/) do
  assessment_answer = @assessment.assessment_answers.create(answer: @positive, question: @first_question)
  assessment_answer.links.create(FactoryGirl.attributes_for(:link))
end

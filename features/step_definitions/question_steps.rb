Given(/^the test survey has been loaded$/) do
  config = File.join( __dir__, "..", "..", "spec", "lib", "test-survey.xls" )    
  QuestionnaireImporter.load(1, config)
  Rails.logger.info "Loaded test survey with: #{Question.count} questions and #{Answer.count} answers.\n"
end

Given(/^I have started an assessment$/) do
  @assessment = FactoryGirl.create(:unfinished_assessment, user_id: @current_user.id)
end

Given(/^I have completed an assessment$/) do
  @assessment = FactoryGirl.create(:assessment, user_id: @current_user.id)
  q = Question.where(code: "Q1").first
  a = Answer.where(code: "Q1.2").first
  @assessment.assessment_answers.create(question: q, answer: a)
  @assessment.complete
end

When(/^I go to the first question$/) do
  first_question = Question.where(code: "Q1").first
  visit assessment_question_path(@assessment, first_question)
end

When(/^I go back to the first question$/) do
  visit assessment_edit_answer_path(@assessment, @assessment.assessment_answers.first)
end

Given(/^I have answered the first question including a link$/) do
  positive = Answer.where(code: "Q1.1").first
  first_question = Question.where(code: "Q1").first
  assessment_answer = @assessment.assessment_answers.create(answer: positive, question: first_question)
  assessment_answer.links.create(FactoryGirl.attributes_for(:link))
end

Given(/^I have completed the first activity$/) do
  positive = Answer.where(code: "Q1.1").first
  first_question = Question.where(code: "Q1").first
  negative = Answer.where(code: "Q2.2").first
  second_question = Question.where(code: "Q2").first  
  @assessment.assessment_answers.create(answer: positive, question: first_question)
  @assessment.assessment_answers.create(answer: negative, question: second_question, notes: "more info on q2")
  Rails.logger.info("\n ------------------------ \n #{negative.to_json} \n #{second_question.to_json} \n")
end

require 'spec_helper'

describe AssessmentAnswer do
  
  describe "creation" do
    context "valid attributes" do
      it "should be valid" do
        answer = FactoryGirl.build(:assessment_answer)
        answer.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        answer = FactoryGirl.build(:assessment_answer, answer_id: nil)
        answer.should_not be_valid
      end

      it "should not have same question id as another assessment answer" do
        existing = FactoryGirl.create(:assessment_answer)
        answer = FactoryGirl.build(:assessment_answer, question_id: existing.question_id, answer: FactoryGirl.create(:negative_answer))
        answer.should_not be_valid
      end
    end
  end

  it "should touch parent assessment" do
    config = File.join( "#{Rails.root}/spec/lib", "test-survey.xls" )
    QuestionnaireImporter.load(1, config)

    activity = Activity.first
    assessment = FactoryGirl.create(:assessment)
    updated_at = assessment.updated_at
    q1 = activity.questions.first
    answer = Answer.where(code: "Q1.1").first
    
    a1 = FactoryGirl.create(:assessment_answer, question: q1, answer: answer, assessment: assessment)
    
    expect( assessment.updated_at ).to_not eql(updated_at)
  end
  
  describe "#proceeding_answers" do
    it "should return a collection of the next answers for an activity" do
      config = File.join( "#{Rails.root}/spec/lib", "test-survey.xls" )
      QuestionnaireImporter.load(1, config)

      activity = Activity.first
      assessment = FactoryGirl.create(:assessment)

      q1 = activity.questions.first
      q2 = activity.questions.second

      answer = Answer.where(code: "Q1.1").first
      answer2 = Answer.where(code: "Q2.1").first
      
      a1 = FactoryGirl.create(:assessment_answer, question: q1, answer: answer, assessment: assessment)
      a2 = FactoryGirl.create(:assessment_answer, question: q2, answer: answer2, assessment: assessment)

      expect(a1.proceeding_answers.count).to eq(1)
    end
  end

  describe "removing later answers" do
    it "should remove further answers when an answer is changed to negative" do
      config = File.join( "#{Rails.root}/spec/lib", "test-survey.xls" )
      QuestionnaireImporter.load(1, config)

      assessment = FactoryGirl.create(:assessment)
      activity = Activity.first

      q1 = activity.questions.first
      q2 = activity.questions.second

      answer = Answer.where(code: "Q1.1").first
      answer2 = Answer.where(code: "Q2.1").first
      
      a1 = FactoryGirl.create(:assessment_answer, question: q1, answer: answer, assessment: assessment)
      a2 = FactoryGirl.create(:assessment_answer, question: q2, answer: answer2, assessment: assessment)

      answer_neg = Answer.where(code: "Q1.2").first
      a1.update_attributes(answer: answer_neg)

      expect(AssessmentAnswer.exists?(id: a2.id)).to eq(false)
    end
  end

end

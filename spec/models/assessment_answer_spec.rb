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
        answer = FactoryGirl.build(:assessment_answer, question_id: existing.question_id)
        answer.should_not be_valid
      end
    end
  end

end

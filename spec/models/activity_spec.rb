require 'spec_helper'

describe Activity do

  describe "#next_question_for(assessment)" do
    let (:assessment) { FactoryGirl.create(:assessment) }
    let (:activity) do
      activity = FactoryGirl.create(:activity)
      activity.questions.create(FactoryGirl.attributes_for(:question))
      activity.questions.create(FactoryGirl.attributes_for(:question, code: "q2"))
      activity.questions.create(FactoryGirl.attributes_for(:question, code: "q3"))
      activity
    end
    let (:positive_answer) { FactoryGirl.create(:answer) }
    let (:negative_answer) { FactoryGirl.create(:negative_answer) }

    context 'when no questions have been answered' do 
      it "should return the first question for the activity" do
        expect(activity.next_question_for(assessment)).to eq(activity.questions.order(:id).first)
      end
    end

    context 'when a question has been answered positively' do
      it "should return the second question" do
        assessment.assessment_answers.create(question: activity.questions.order(:id).first, answer: positive_answer)
        expect(activity.next_question_for(assessment)).to eq(activity.questions.order(:id).second)
      end
    end
  end

  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        activity = FactoryGirl.build(:activity)
        activity.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        activity = FactoryGirl.build(:activity, name: "")
        activity.should_not be_valid

        activity = FactoryGirl.build(:activity, title: "")
        activity.should_not be_valid
      end

      it "should not support duplicates" do
        activity = FactoryGirl.build(:activity)
        activity.save
        activity2 = FactoryGirl.build(:activity)
        activity2.should_not be_valid
      end
    end

  end
end

require 'spec_helper'

describe Question do

  describe "#prev" do
    it "should return the previous question" do
      q1 = FactoryGirl.create(:question, code: "q1")
      q2 = FactoryGirl.create(:question, code: "q2")
      expect(q2.prev).to eq(q1)
    end
  end

  describe "#next" do 
    it "should return the next question" do
      q1 = FactoryGirl.create(:question, code: "q1")
      q2 = FactoryGirl.create(:question, code: "q2")
      expect(q1.next).to eq(q2)
    end
  end

  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        question = FactoryGirl.build(:question)
        question.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        question = FactoryGirl.build(:question, text: "")
        question.should_not be_valid

        question = FactoryGirl.build(:question, code: "")
        question.should_not be_valid

      end

      it "should not support duplicates" do
        question = FactoryGirl.build(:question)
        question.save
        question2 = FactoryGirl.build(:question)
        question2.should_not be_valid
      end
    end

  end
end

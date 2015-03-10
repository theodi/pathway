require 'spec_helper'

describe Question do
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

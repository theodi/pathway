require 'spec_helper'

describe Questionnaire do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        questionnaire = FactoryGirl.build(:questionnaire)
        questionnaire.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        questionnaire = FactoryGirl.build(:questionnaire, version: "")
        questionnaire.should_not be_valid
      end

      it "should not support duplicates" do
        questionnaire = FactoryGirl.build(:questionnaire)
        questionnaire.save
        questionnaire2 = FactoryGirl.build(:questionnaire)
        lambda do
          questionnaire2.save
        end.should raise_error
      end
    end

  end

end

require 'spec_helper'

describe Activity do
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

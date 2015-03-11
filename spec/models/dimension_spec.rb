require 'spec_helper'

describe Dimension do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        dimension = FactoryGirl.build(:dimension)
        dimension.should be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        dimension = FactoryGirl.build(:dimension, name: "")
        dimension.should_not be_valid

        dimension = FactoryGirl.build(:dimension, title: "")
        dimension.should_not be_valid

      end

      it "should not support duplicates" do
        dimension = FactoryGirl.build(:dimension)
        dimension.save
        dimension2 = FactoryGirl.build(:dimension)
        dimension2.should_not be_valid
      end
    end

  end
end

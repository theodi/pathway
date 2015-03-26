require 'spec_helper'

describe Improvement do
  describe "creation" do
  
      context "valid attributes" do
        it "should be valid" do
          improvement = FactoryGirl.build(:improvement)
          improvement.should be_valid
        end
      end
  
      context "invalid attributes" do
        it "should not be valid" do
          improvement = FactoryGirl.build(:improvement, notes: "")
          improvement.should_not be_valid
  
          improvement = FactoryGirl.build(:improvement, code: "")
          improvement.should_not be_valid
  
        end
  
        it "should not support duplicates" do
          improvement = FactoryGirl.build(:improvement)
          improvement.save
          improvement2 = FactoryGirl.build(:improvement)
          improvement2.should_not be_valid
        end
        
      end
  
    end

end

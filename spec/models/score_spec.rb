require 'spec_helper'

describe Score do
  describe "creation" do
    
    it "should allow only legal scores" do
      score = FactoryGirl.build(:score, score: 6)
      score.should_not be_valid

      score = FactoryGirl.build(:score, score: 0)
      score.should_not be_valid               
    end
    
    it "should allow only legal targets" do
      score = FactoryGirl.build(:score, target: 6)
      score.should_not be_valid

      score = FactoryGirl.build(:score, target: 0)
      score.should_not be_valid               
    end
  end
end

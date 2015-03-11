require 'spec_helper'

describe Answer do
  describe "creation" do
 
     context "valid attributes" do
       it "should be valid" do
         answer = FactoryGirl.build(:answer)
         answer.should be_valid
         answer = FactoryGirl.build(:negative_answer)
         answer.should be_valid

       end
     end
 
     context "invalid attributes" do
       it "should not be valid" do
         answer = FactoryGirl.build(:answer, text: "")
         answer.should_not be_valid
 
         answer = FactoryGirl.build(:answer, code: "")
         answer.should_not be_valid
 
       end
 
       it "should not support duplicates" do
         answer = FactoryGirl.build(:answer)
         answer.save
         answer2 = FactoryGirl.build(:answer)
         answer2.should_not be_valid
       end
       
       it "should allow only legal scores" do
         answer = FactoryGirl.build(:answer, score: 6)
         answer.should_not be_valid

         answer = FactoryGirl.build(:answer, score: 0)
         answer.should_not be_valid
                  
       end
       
       it "should require a score for negative answers" do
         answer = FactoryGirl.build(:negative_answer, score: nil)
         answer.should_not be_valid

       end
     end
 
   end
end

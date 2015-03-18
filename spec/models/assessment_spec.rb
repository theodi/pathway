require 'spec_helper'

describe Assessment do

  context "when completing" do
    
    before(:each) do
      config = File.join( __dir__, "..", "lib", "test-survey.xls" )    
      QuestionnaireImporter.load(1, config)    
    end
    let(:assessment) { FactoryGirl.create :unfinished_assessment }
    let!(:assessment_answer) { AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") ) }
          
    it "should identify when complete" do
      assessment = FactoryGirl.create(:assessment)
      expect( assessment.status ).to eql(:complete)
    end
    
    it "should identify when incomplete" do
      expect( assessment.status ).to eql(:incomplete)
    end
    
    it "should set completion date" do
      assessment.complete
      expect( assessment.completion_date ).to_not be_nil
      expect( assessment.status ).to eql(:complete)      
    end
    
    it "should only complete if allowed" do
      AssessmentAnswer.destroy_all
      assessment.complete
      expect( assessment.status ).to eql(:incomplete)   
    end
    
    it "should store scores" do
      assessment.complete
      expect( assessment.scores.length ).to eql(1)
      expect( Score.first.score ).to eql(1)
    end
    
  end
end

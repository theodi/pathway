require 'spec_helper'
require 'assessment_scorer'
require 'questionnaire_importer'
require 'progress_calculator'

describe AssessmentScorer do

  before(:each) do
    config = File.join( __dir__, "test-survey.xls" )    
    QuestionnaireImporter.load(1, config)    
  end
    
  context '.score_activity' do
    let(:assessment) { FactoryGirl.create :assessment }
    let(:scorer) { AssessmentScorer.new(assessment) }
    let(:activity) { Activity.first } #Data release process from test-survey.xls
        
    it "should fail if not complete" do
      lambda do
        scorer.score_activity( activity )
      end.should raise_error
    end
    
    it "should score to first negative answer" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      expect( scorer.score_activity( activity) ).to eql(1)
    end
    
    it "should score to later negative answer" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.1") )
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q2.2") )
      expect( scorer.score_activity( activity) ).to eql(2)
    end
    
    it "should score whole assessment" do
      #positive answer to all questions
      Question.all.each do |q|
        AssessmentAnswer.create( assessment: assessment, question: q, answer: q.answers.where(positive: true).first )
      end
      expect( scorer.score_activity( activity) ).to eql(5)
    end
    
  end

  context '.score_activities' do
    let(:assessment) { FactoryGirl.create :assessment }
    let(:scorer) { AssessmentScorer.new(assessment) }
    let(:activity) { Activity.first } #Data release process from test-survey.xls

    it "should score all activities" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )

      progress = scorer.score_activities
      expect( progress["data-release-process"] ).to eql(1)
    end
    
  end
  
  context '.score_dimension' do
    let(:assessment) { FactoryGirl.create :assessment }
    let(:scorer) { AssessmentScorer.new(assessment) }
    let(:activity) { Activity.first } #Data release process from test-survey.xls
    let(:dimension) { Dimension.first } #Data management process from test-survey.xls

    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )      
    }
    
    it "should score a single dimension" do
      result = scorer.score_dimension( dimension )
      expect( result[:score] ).to eql( 1 )
    end
    
    it "should identify maximum score for a dimension" do
      result = scorer.score_dimension( dimension )
      expect( result[:max] ).to eql( 5 )
    end
    
  end

  context '.score_dimensions' do
    let(:assessment) { FactoryGirl.create :assessment }
    let(:scorer) { AssessmentScorer.new(assessment) }
    let(:activity) { Activity.first } #Data release process from test-survey.xls
    let(:dimension) { Dimension.first } #Data management process from test-survey.xls

    it "should score all dimensions" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )  
      scores = scorer.score_dimensions
      expect( scores["data-management-processes"] ).to eql( { score: 1, max: 5 })
    end
  end

  
end
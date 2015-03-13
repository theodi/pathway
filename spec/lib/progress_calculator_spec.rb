require 'spec_helper'
require 'questionnaire_importer'
require 'progress_calculator'

describe ProgressCalculator do
  
  before(:all) do
    config = File.join( __dir__, "test-survey.xls" )    
    QuestionnaireImporter.load(1, config)    
  end
  
  context ".completed?" do
    let(:assessment) { FactoryGirl.create :unfinished_assessment }
    let(:calculator) { ProgressCalculator.new(assessment) }

    it "should check completion date" do
      expect( calculator.completed? ).to eql(false)
      assessment.completion_date = "2015-03-10 11:07:10"
      expect( calculator.completed? ).to eql(true)
    end
    
  end
  
  context ".progress_for_activity" do
    let(:assessment) { FactoryGirl.create :unfinished_assessment }
    let(:calculator) { ProgressCalculator.new(assessment) }
    let(:activity) { Activity.first } #Data release process from test-survey.xls
    
    it "is not started if no answers" do
      expect( calculator.progress_for_activity( activity ) ).to eql(:not_started)
    end
    
    it "is in progress if not all answers are answered" do      
      #positive answer to first question
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.first )
      expect( calculator.progress_for_activity( activity ) ).to eql(:in_progress)      
    end
    
    it "is completed if all necessary questions answered" do
      #negative answer to first question
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      expect( calculator.progress_for_activity( activity ) ).to eql(:completed)      
    end
      
    it "is completed if all answered" do
      #positive answer to all questions
      Question.all.each do |q|
        AssessmentAnswer.create( assessment: assessment, question: q, answer: q.answers.where(positive: true).first )
      end
      
      expect( calculator.progress_for_activity( activity ) ).to eql(:completed)      

    end

    it "is skipped if no questions to answer" do
      new_activity = Activity.create(name: "new-activity", title: "New activity", dimension: Dimension.first)
      expect( calculator.progress_for_activity( new_activity ) ).to eql(:skipped)
    end
  end
  
  context ".progress_for_all_activities" do
    let(:assessment) { FactoryGirl.create :unfinished_assessment }
    let(:calculator) { ProgressCalculator.new(assessment) }

    it "should report status of all activities" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.first )
      progress = calculator.progress_for_all_activities

      expect( progress["data-release-process"] ).to eql(:in_progress)
      expect( progress["standards-development-adoption"] ).to eql(:skipped)
        
    end
  end   
  
  context ".percentage_progress" do
    let(:assessment) { FactoryGirl.create :unfinished_assessment }
    let(:calculator) { ProgressCalculator.new(assessment) }

    it "should be zero if no answers" do
      expect( calculator.percentage_progress ).to eql(0)
    end
    
    it "should be 100% if all completed or skipped" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      expect( calculator.percentage_progress ).to eql(100)
    end
    
    it "should be zero if no activities completed" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.first )
      expect( calculator.percentage_progress ).to eql(0)
    end

    it "should be 50% if only one activity completed" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      
      governance = Activity.find_by_name("data-governance")
      q = Question.create(code: "X1", activity: governance, questionnaire: Questionnaire.first, text: "Do you even govern?")
      Answer.create( code: "X1.1", text: "Yes", question: q, positive: true)
      Answer.create( code: "X1.1", text: "No", question: q, score: 1, positive: false)
      
      expect( calculator.percentage_progress ).to eql(50)
    end
  end
  
  context ".can_mark_completed?" do
    let(:assessment) { FactoryGirl.create :unfinished_assessment }
    let(:calculator) { ProgressCalculator.new(assessment) }

    it "cannot be marked as completed if not all assessments are complete" do
      expect( calculator.can_mark_completed? ).to eql(false)
    end
    
    it "can be completed if all assessments are complete" do
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      expect( calculator.can_mark_completed? ).to eql(true)  
      
    end
  end
end
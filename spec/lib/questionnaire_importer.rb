require 'spec_helper'
require 'questionnaire_importer'

describe QuestionnaireImporter do 
  
  before(:all) do
    @config = File.join( __dir__, "test-survey.xls" )
    
  end
  
  describe '.create_questionnaire' do
    it "should create a new questionnaire" do
      QuestionnaireImporter.create_questionnaire(1,"My notes")
      expect( Questionnaire.count ).to eql(1)
      expect( Questionnaire.first.version).to eql(1)
      expect( Questionnaire.first.notes).to eql("My notes")
    end
  end
  
  describe '.populate_activities' do
    
    before(:all) do
      book = Spreadsheet.open @config
      @activities = book.worksheet 'activities'
      @questionnaire = Questionnaire.create(version: 1)
      QuestionnaireImporter.populate_activities(@questionnaire,@activities)
    end
    
    after(:all) do
      Questionnaire.destroy_all
      Dimension.destroy_all
      Activity.destroy_all
    end
    
    it "should populate dimensions" do
      expect( Dimension.count ).to eql(5)
      expect( Dimension.last.name ).to eql("strategy-governance")
      expect( Dimension.last.title ).to eql("Strategy & governance")
      expect( Dimension.last.activities.count ).to eql(2)
      expect( @questionnaire.dimensions.count ).to eql(5)
    end
    
    it "should populate activities" do
      expect( Activity.count ).to eql(15)
      expect( Activity.first.name ).to eql("data-release-process")
      expect( Activity.first.title ).to eql("Data release process")
      expect( @questionnaire.activities.count ).to eql(15)
    end
   
  end
  
  describe '.populate_questions' do
    
    before(:all) do
      book = Spreadsheet.open @config
      @questionnaire = Questionnaire.create(version: 1)
      QuestionnaireImporter.populate_activities(@questionnaire, book.worksheet('activities') )
      QuestionnaireImporter.populate_answers(@questionnaire, book.worksheet('questions') )
    end
    
    after(:all) do
      Questionnaire.destroy_all
      Dimension.destroy_all
      Activity.destroy_all
      Question.destroy_all
      Answer.destroy_all
    end
        
    it "should populate questions" do
      expect( Question.count ).to eql(5)
      expect( Question.first.code ).to eql("Q1")
      expect( Question.first.text ).to eql("Have you published any open data?")
      expect( Question.first.notes ).to eql("notes")

      expect( Question.first.answers.count ).to eql(2)
      expect( Question.first.activity.title ).to eql("Data release process")
      expect( Question.first.questionnaire.version).to eql(1)
      
      expect( Question.last.dependency.code ).to eql("Q4")
    end
    
    it "should populate answers" do
      expect( Answer.count ).to eql(11)
      expect( Answer.last.code ).to eql("Q5.2")
      expect( Answer.last.text).to eql("No")
      expect( Answer.last.positive?).to eql(false)
      expect( Answer.last.score).to eql(4)
      expect( Answer.last.question.code).to eql("Q5")
      expect( Answer.last.questionnaire.version).to eql(1)
    end
  end
end

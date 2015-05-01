require 'spec_helper'

describe StatisticsController do
  
  before(:each) do
    config = File.join( __dir__, "..", "lib", "test-survey.xls" )    
    QuestionnaireImporter.load(1, config)    
  end
   
  context "when request summary data" do

    before(:each) do
      FactoryGirl.create(:user)
      FactoryGirl.create(:organisation)
      FactoryGirl.create(:organisation_user, email: "other@example.org")
      FactoryGirl.create(:assessment)
      FactoryGirl.create(:unfinished_assessment)
      
      get "summary", format: "json"
      expect( response ).to be_success
      @json = JSON.parse(response.body)      
    end
    
    context "as json" do

      it "should return questionnaire version" do
        expect( @json["questionnaire_version"] ).to eql(1)
      end

      it "should return number of users" do
        expect( @json["registered_users"] ).to eql(2)
      end
      
      it "should return number of orgs" do
        expect( @json["organisations"]["total"]).to eql(1)
      end
      
      it "should return number of orgs with users" do
        expect( @json["organisations"]["total_with_users"] ).to eql(1)
      end
      
      it "should number of dgu orgs" do
        expect( @json["organisations"]["datagovuk"] ).to eql(1)
      end
      
      it "should return number of assessments" do
        expect( @json["assessments"]["total"] ).to eql(2)
      end
      it "should return number of completed assessments" do
        expect( @json["assessments"]["completed"] ).to eql(1)
      end
      
    end
    
  end

  context "when requesting organisational stats" do
        
    context "as json" do

      before(:each) do
        org = FactoryGirl.create(:organisation)
        user = FactoryGirl.create(:organisation_user, email: "other@example.org", organisation: org)
        assessment = FactoryGirl.create(:assessment, user: user)
        
        AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
        assessment.complete

        FactoryGirl.create(:unfinished_assessment)
  
        get "all_organisations", format: "json"
        expect( response ).to be_success
        @json = JSON.parse(response.body)      
        
      end
            
      it "should return number of organisations" do        
        expect( @json["organisations"] ).to eql(1)
      end
      
      it "should return number of assessments" do
        expect( @json["completed"] ).to eql(1)
      end
      
      it "should return scores" do 
        expect( @json["themes"]["Data management processes"]["Data release process"] ).to eql([1,0,0,0,0])
      end
      
      it "should return level names" do
        expect( @json["level_names"] ).to eql( ["Initial", "Repeatable", "Defined", "Managed", "Optimising"] )
      end
      
    end
  end
end
require 'spec_helper'
require 'organisation_scorer'
require 'questionnaire_importer'
require 'progress_calculator'

describe OrganisationScorer do

  before(:each) do
    config = File.join( __dir__, "test-survey.xls" )    
    QuestionnaireImporter.load(1, config)    
  end
      
  context ".score_organisations" do
    let!(:organisation) { FactoryGirl.create :organisation }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }
    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
  
    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete
    }
    
    it "should return organisation count" do
      expect( scorer.score_organisations( Organisation.all )[:children] ).to eql(1)
    end
    
    it "should return number of completed assessments" do
      expect( scorer.score_organisations( Organisation.all )[:completed] ).to eql(1)      
    end
    it "should score all activities" do
      expect( scorer.score_organisations(Organisation.all)[:activities].keys.size ).to eql(Activity.all.count)
    end
    
    it "should count totals for an activity" do
      scores = scorer.score_organisations(Organisation.all)[:activities]
      expect( scores[ Activity.first.name ][0] ).to eql(1) 
      expect( scores[ Activity.first.name ][1] ).to eql(0)   
    end
          
    it "should only count completed assessments" do
      ua = FactoryGirl.create :unfinished_assessment, user: user
      AssessmentAnswer.create( assessment: ua, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      results = scorer.score_organisations( Organisation.all )
      expect( results[:completed] ).to eql(1)        
      expect( results[:activities][Activity.first.name][0]).to eql(1)
    end
    
  end
  
  context ".score_all_organisations" do

    let!(:organisation) { FactoryGirl.create :organisation }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }
    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
  
    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete
    }
        
    it "should count all organisations" do
      org = FactoryGirl.create :organisation, title: "other"
      u = FactoryGirl.create :user, organisation: org, email: "other@example.org"
      a = FactoryGirl.create :assessment, user: u
      AssessmentAnswer.create( assessment: a, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      a.complete
      results = scorer.score_all_organisations
      expect( results[:children] ).to eql(2)
      expect( results[:completed] ).to eql(2)
      expect( results[:activities][ Activity.first.name ][0] ).to eql(2)
    end

  end
  
  context ".score_dgu_organisations" do

    let!(:organisation) { FactoryGirl.create :organisation }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }
    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
  
    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete
    }
        
    it "should count only d.g.u organisations" do
      #this one should be ignored
      org = FactoryGirl.create :organisation, title: "other", dgu_id: nil
      u = FactoryGirl.create :user, organisation: org, email: "other@example.org"
      a = FactoryGirl.create :assessment, user: u
      AssessmentAnswer.create( assessment: a, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      a.complete
      results = scorer.score_dgu_organisations
      expect( results[:children] ).to eql(1)
      expect( results[:completed] ).to eql(1)
      expect( results[:activities][ Activity.first.name ][0] ).to eql(1)
    end

      
  end

  context ".score_children" do      
    let!(:parent_organisation) { FactoryGirl.create :organisation, title: "parent", dgu_id: nil }
    let!(:organisation) { FactoryGirl.create :organisation, parent: parent_organisation.id }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }

    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
  
    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete      
    }

    it "should score children" do
      results = scorer.score_children(parent_organisation)
      expect( results[:children] ).to eql(1)
      expect( results[:completed] ).to eql(1)
      expect( results[:activities][ Activity.first.name ][0] ).to eql(1)
    end
      
    it "should score only those associated with the parent" do
      organisation.parent = nil
      organisation.save!
      results = scorer.score_children(parent_organisation)
      expect( results[:children] ).to eql(0)
      expect( results[:completed] ).to eql(0)
    end
      
  end
  
  context ".normalise_counts" do
    let!(:scorer) { OrganisationScorer.new }
      
    it "should normalise to bins" do
      results = {
        activities: {
          "data-management-processes" => [0, 3, 5, 6, 0],
          "standards" => [0, 15, 0, 0, 0],
          "governance" => [1, 10, 4, 0, 0]
        },
        children: 15,
        completed: 15  
      }  
      normalised = scorer.normalise_counts(results)
      expect( normalised[:children] ).to eql(15)
      expect( normalised[:completed] ).to eql(15)
      expect( normalised[:activities]["data-management-processes"] ).to eql([0,1,2,2,0]) 
      expect( normalised[:activities]["standards"] ).to eql([0,5,0,0,0]) 
      expect( normalised[:activities]["governance"] ).to eql([1,4,2,0,0]) 
    end  
    
    it "should normalise correctly" do
      results = {
        activities: {
          "data-management-processes" => [1, 0, 0, 0, 0],
          "standards" => [0, 0, 0, 0, 0]
        },
        children: 1000,
        completed: 1  
      }  
      normalised = scorer.normalise_counts(results)
      expect( normalised[:children] ).to eql(1000)
      expect( normalised[:completed] ).to eql(1)
      expect( normalised[:activities]["data-management-processes"] ).to eql([5,0,0,0,0]) 
      expect( normalised[:activities]["standards"] ).to eql([0,0,0,0,0]) 
    end      
    
  end
  
end
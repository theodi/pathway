require 'spec_helper'
require 'organisation_scorer'
require 'questionnaire_importer'
require 'progress_calculator'

describe StatisticsGenerator do

  before(:each) do
    config = File.join( __dir__, "test-survey.xls" )    
    QuestionnaireImporter.load(1, config)    
  end

  context ".generate_stats_for_all_organisations" do
    let!(:group) { FactoryGirl.create :organisation, title: "All Organisations" }
    let!(:organisation) { FactoryGirl.create :organisation }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }
    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
      
    let(:generator) { StatisticsGenerator.new }  

    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete
    }
  
    it "should score all activities" do
      generator.generate_stats_for_all_organisations
      expect( OrganisationScore.count ).to eql( Activity.all.count )
    end
    
    it "should store against the right group" do
      generator.generate_stats_for_all_organisations
      expect( OrganisationScore.where( organisation: group ).size ).to eql(Activity.all.count)
    end
    
    it "should count totals for an activity" do
      generator.generate_stats_for_all_organisations
      score = OrganisationScore.where( organisation: group, activity: Activity.first ).first
      expect( score.initial ).to eql(1)
      expect( score.defined ).to eql(0)
    end
          
    it "should only count completed assessments" do
      ua = FactoryGirl.create :unfinished_assessment, user: user
      AssessmentAnswer.create( assessment: ua, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      generator.generate_stats_for_all_organisations
      score = OrganisationScore.where( organisation: group, activity: Activity.first ).first
      expect( score.initial ).to eql(1)
    end
    
    it "should update existing statistics" do
      OrganisationScore.create!( organisation: group, activity: Activity.first, initial: 15)
      generator.generate_stats_for_all_organisations
      score = OrganisationScore.where( organisation: group, activity: Activity.first ).first
      expect( score.initial ).to eql(1)      
    end
  end
  
  context ".generate_stats_for_dgu_organisations" do
    let!(:group) { FactoryGirl.create :organisation, title: "All data.gov.uk organisations" }
    let!(:organisation) { FactoryGirl.create :organisation }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }
    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
      
    let(:generator) { StatisticsGenerator.new }  

    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete
    }
  
    it "should store against the right group" do
      generator.generate_stats_for_dgu_organisations
      expect( OrganisationScore.where( organisation: group ).size ).to eql(Activity.all.count)
    end
    
    it "should count totals for an activity" do
      generator.generate_stats_for_dgu_organisations
      score = OrganisationScore.where( organisation: group, activity: Activity.first ).first
      expect( score.initial ).to eql(1)
      expect( score.defined ).to eql(0)
    end
          
    it "should update existing statistics" do
      OrganisationScore.create!( organisation: group, activity: Activity.first, initial: 15)
      OrganisationScore.create!( organisation: FactoryGirl.create(:organisation, title: "All Organisations"), activity: Activity.first, initial: 20)
      
      generator.generate_stats_for_dgu_organisations
      score = OrganisationScore.where( organisation: group, activity: Activity.first ).first
      expect( score.initial ).to eql(1)      
    end
    
  end
  
  context ".generate_stats_for_dgu_groups" do
    let!(:parent_organisation) { FactoryGirl.create :organisation, title: "parent", dgu_id: nil }
    let!(:organisation) { FactoryGirl.create :organisation, parent: parent_organisation.id }
    let!(:user) { FactoryGirl.create :organisation_user, organisation: organisation }

    let!(:assessment) { FactoryGirl.create :assessment, user: user }
    let!(:scorer) { OrganisationScorer.new }
      
    let(:generator) { StatisticsGenerator.new }  

    before(:each) {
      AssessmentAnswer.create( assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
      assessment.complete
    }
     
    it "should store against the right group" do
      generator.generate_stats_for_dgu_groups
      expect( OrganisationScore.where( organisation: parent_organisation ).size ).to eql(Activity.all.count)
      expect( OrganisationScore.where( organisation: organisation ).size ).to eql(0)
    end
    
    it "should count totals for an activity" do
      generator.generate_stats_for_dgu_groups
      score = OrganisationScore.where( organisation: parent_organisation, activity: Activity.first ).first
      expect( score.initial ).to eql(1)
      expect( score.defined ).to eql(0)
    end
       
  end

end
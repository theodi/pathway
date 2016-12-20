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

  context "when request country summary data" do

    before(:each) do
      FactoryGirl.create(:user)
      FactoryGirl.create(:organisation)
      FactoryGirl.create(:country)
      FactoryGirl.create(:organisation_user, email: "other@example.org")
      FactoryGirl.create(:country_user)
      FactoryGirl.create(:country_organisation_user_with_assessments)

      get "summary_by_country", format: "json"
      expect( response ).to be_success
      @json = JSON.parse(response.body)
    end

    it "should return country summary including countries, not specified, and all other countries" do
      expect( @json).to eql(JSON.parse('[{
          "country":"Uruguay",
          "registered_users":1,
          "users_with_organisations":1,
          "assessments":{"completed":5, "total":5},
          "questionnaire_version":1
        },{
          "country":"Not specified",
          "registered_users":2,
          "users_with_organisations":1,
          "assessments":{"completed":0, "total":0},
          "questionnaire_version":1
        },{
          "country":"All other countries",
          "registered_users":1,
          "users_with_organisations":0,
          "assessments":{"completed":0, "total":0},
          "questionnaire_version":1
         }]'))
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

        Organisation.create!(title: "All Organisations")
        Organisation.create!(title: "All data.gov.uk organisations")
        generator = StatisticsGenerator.new
        generator.generate_all

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
  
  context "when request all organisations by country" do

    before(:each) do
      FactoryGirl.create(:organisation)
      FactoryGirl.create(:user)
      country = FactoryGirl.create(:country)
      [1,2,3,4,5].each do |count|
         FactoryGirl.create(:"organisation#{count}")
         user = FactoryGirl.create(:organisation_user2, email: "user#{count}@example.org", country_id: country.id, organisation_id: count)
         assessment = FactoryGirl.create(:assessment, user: user)
         AssessmentAnswer.create(assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
         assessment.complete
      end

      generator = StatisticsGenerator.new
      generator.generate_stats_for_all_countries
      
      CountryScoresDatum.all.each do | score|
        puts "next datum: #{score.inspect}"
      end
      get "all_organisations_by_country", format: "json"
      expect( response ).to be_success
      @json = JSON.parse(response.body)
    end

    it "should return all organisations by country, including not specified, and all other countries" do
      expect( @json).to eql(JSON.parse('[
      {"country":"United Kingdom",
         "completed":5,
         "organisations":5,
         "themes":
          {"Data management processes":
            {"Data release process":[5, 0, 0, 0, 0],
             "Standards development & adoption":[0, 0, 0, 0, 0],
             "Data governance":[0, 0, 0, 0, 0],
             "Data defusing":[0, 0, 0, 0, 0]},
           "Knowledge & skills":
            {"Open data expertise":[0, 0, 0, 0, 0],
             "Knowledge management":[0, 0, 0, 0, 0]},
           "Customer support & engagement":
            {"Engagement process":[0, 0, 0, 0, 0],
             "Open data documentation":[0, 0, 0, 0, 0],
             "Reuser support processes":[0, 0, 0, 0, 0],
             "Community norms":[0, 0, 0, 0, 0]},
           "Investment & financial performance":
            {"Financial oversight":[0, 0, 0, 0, 0],
             "Dataset valuation process":[0, 0, 0, 0, 0],
             "Open data in procurement":[0, 0, 0, 0, 0]},
           "Strategy & governance":
            {"Open data strategy":[0, 0, 0, 0, 0],
             "Asset catalogue":[0, 0, 0, 0, 0]}}},
         
         {"country":"All other countries",
          "completed":0,
          "organisations":0,
         "themes":
          {"Data management processes":
            {"Data release process":[0, 0, 0, 0, 0],
             "Standards development & adoption":[0, 0, 0, 0, 0],
             "Data governance":[0, 0, 0, 0, 0],
             "Data defusing":[0, 0, 0, 0, 0]},
           "Knowledge & skills":
            {"Open data expertise":[0, 0, 0, 0, 0],
             "Knowledge management":[0, 0, 0, 0, 0]},
           "Customer support & engagement":
            {"Engagement process":[0, 0, 0, 0, 0],
             "Open data documentation":[0, 0, 0, 0, 0],
             "Reuser support processes":[0, 0, 0, 0, 0],
             "Community norms":[0, 0, 0, 0, 0]},
           "Investment & financial performance":
            {"Financial oversight":[0, 0, 0, 0, 0],
             "Dataset valuation process":[0, 0, 0, 0, 0],
             "Open data in procurement":[0, 0, 0, 0, 0]},
           "Strategy & governance":
            {"Open data strategy":[0, 0, 0, 0, 0],
             "Asset catalogue":[0, 0, 0, 0, 0]}}},
        
        {"country":"Not specified",
         "completed":0,
         "organisations":0,
         "themes":
          {"Data management processes":
            {"Data release process":[0, 0, 0, 0, 0],
             "Standards development & adoption":[0, 0, 0, 0, 0],
             "Data governance":[0, 0, 0, 0, 0],
             "Data defusing":[0, 0, 0, 0, 0]},
           "Knowledge & skills":
            {"Open data expertise":[0, 0, 0, 0, 0],
             "Knowledge management":[0, 0, 0, 0, 0]},
           "Customer support & engagement":
            {"Engagement process":[0, 0, 0, 0, 0],
             "Open data documentation":[0, 0, 0, 0, 0],
             "Reuser support processes":[0, 0, 0, 0, 0],
             "Community norms":[0, 0, 0, 0, 0]},
           "Investment & financial performance":
            {"Financial oversight":[0, 0, 0, 0, 0],
             "Dataset valuation process":[0, 0, 0, 0, 0],
             "Open data in procurement":[0, 0, 0, 0, 0]},
           "Strategy & governance":
            {"Open data strategy":[0, 0, 0, 0, 0],
             "Asset catalogue":[0, 0, 0, 0, 0]}}},
        {"level_names":
          ["Initial", "Repeatable", "Defined", "Managed", "Optimising"]}
       ]'
         ))
    end
  end

end

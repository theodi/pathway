require 'spec_helper'

describe StatisticsController do
  before(:each) do
    config = File.join( __dir__, "..", "lib", "test-survey.xls" )
    QuestionnaireImporter.load(1, config)
  end

  context "when request summary data" do
    let!(:expected_summary_keys) do
      ["users", "orgs", "org_users", "dgus","assessments","completed_assessments"]
    end
    [
      [
        [:user, :organisation_user,:organisation,:assessment,:unfinished_assessment],
        [:user, :organisation,:country,:organisation_user,:country_user,:country_organisation_user_with_assessments],
        [:country_user, :country_user2, :country_organisation_user_with_assessments ]
      ],
      [
        [2,2,1,2,2,1],
        [4,3,2,3,5,5],
        [3,1,1,1,5,5]
      ]
    ].transpose.each do |given, data|
      context "given #{given}" do
        before(:each) do
          given.each do | factory|
            FactoryGirl.create(factory)
          end
          get "summary", format: "json"
          expect( response ).to be_success
          @json = JSON.parse(response.body)
          @expected = expected_summary_keys.zip(data).to_h
        end
        context "as json, #{data}" do
          it "should return questionnaire version" do
            expect( @json["questionnaire_version"] ).to eql(1)
          end

          it "should return number of users" do
            expect( @json["registered_users"] ).to eql(@expected["users"])
          end

          it "should return number of orgs" do
            expect( @json["organisations"]["total"]).to eql(@expected["orgs"])
          end

          it "should return number of orgs with users" do
            expect( @json["organisations"]["total_with_users"] ).to eql(@expected["org_users"])
          end

          it "should number of dgu orgs" do
            expect( @json["organisations"]["datagovuk"] ).to eql(@expected["dgus"])
          end

          it "should return number of assessments" do
            expect( @json["assessments"]["total"] ).to eql(@expected["assessments"])
          end

          it "should return number of completed assessments" do
            expect( @json["assessments"]["completed"] ).to eql(@expected["completed_assessments"])
          end
        end
      end
    end
  end

  context "when request country summary data" do
    [
      [
        [:user, :organisation_user,:organisation,:assessment,:unfinished_assessment],
        [:user, :organisation,:country,:organisation_user,:country_user,:country_organisation_user_with_assessments],
        [:country_user, :country_user2, :country_organisation_user_with_assessments ]
      ],
      [
        [ ["Not specified", 2,1,0,0], ["All other countries", 0,0,0,0]],
        [ ['Uruguay',1,1,5,5], ["Not specified", 2,1,0,0], ["All other countries", 1,0,0,0]],
        [ ['Uruguay',1,1,5,5], ["Not specified", 0,0,0,0], ["All other countries", 2,0,0,0]]
      ]
    ].transpose.each do |given, data|
      context "given #{given}" do
        before(:each) do
          given.each do | factory|
            FactoryGirl.create(factory)
          end
          get "summary_by_country", format: "json"
          expect( response ).to be_success
          @json = JSON.parse(response.body)
          @create_expected_response= -> (*countries,no_country,other) do
            [*countries,no_country,other].collect do | datum |
                 {
                      country: datum.shift,
                      registered_users:  datum.shift,
                      users_with_organisations: datum.shift,
                      assessments: {
                        completed: datum.shift,
                        total: datum.shift
                      },
                      questionnaire_version: 1
                  }
             end.as_json
          end
        end
        context "as json, #{data}" do
          it "returns country summary including countries" do
            expect(@json).to eql @create_expected_response.(*data)
          end
        end
      end
    end
  end

  context "when requesting organisational stats" do
    factory_create= ->(users, assessments) do
      users.each do |user|
        assessments.each do |assessment|
          assessment.user = user
          AssessmentAnswer.create(assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
          assessment.complete if assessment.completion_date
          assessment.save
        end
      end
    end
    let!(:expected_keys) do
      ["orgs", "completed", "scores"]
    end
    [
      [
        [[:organisation_user], [:unfinished_assessment, :assessment]],
        [[:organisation_user], [:unfinished_assessment]],
        [[:organisation_user_with_assessments], [:assessment,:unfinished_assessment]],
        [[:organisation_sequence_user] * 2, [:assessment]],
        [[:organisation_sequence_user] * 2, [:assessment] * 3],
        [[:organisation_sequence_user], [:assessment] * 4]
      ],
      [
        [[1,1,[1,0,0,0,0]],[1,1,{}]],
        [[1,0,{}],[1,0,{}]],
        [[1,1,[1,0,0,0,0]],[1,1,{}]],
        [[2,2,[2,0,0,0,0]],[2,2,{}]],
        [[2,2,[2,0,0,0,0]],[2,2,{}]],
        [[1,1,[1,0,0,0,0]],[1,1,{}]]
      ]
    ].transpose.each do |given,data|
      context "given subjects: #{given}" do
        before(:each) do
          factories_created = given.collect do |factories|
            factories.collect do |factory|
              FactoryGirl.create(:"#{factory}")
            end
          end
          factory_create.(*factories_created)
          Organisation.create!(title: "All Organisations")
          Organisation.create!(title: "All data.gov.uk organisations")
          generator = StatisticsGenerator.new
          generator.generate_all
        end
        [data, [1,5]].transpose.each do |datum, threshold|
          context "with theshold of #{threshold}, expecting data #{datum} as json" do
            before(:each) do
              stub_const("ODMAT::Application::HEATMAP_THRESHOLD", threshold)
              get "all_organisations", format: "json"
              expect( response ).to be_success
              @json = JSON.parse(response.body)
              @expected = expected_keys.zip(datum).to_h
            end
            it "returns number of organisations" do
              expect( @json["organisations"] ).to eql(@expected["orgs"])
            end
            it "returns number of assessments completed" do
              expect( @json["completed"] ).to eql(@expected["completed"])
            end

            it "returns scores" do
              if @json["themes"]["Data management processes"] then
                expect( @json["themes"]["Data management processes"]["Data release process"] ).to eql(@expected["scores"])
              else
                expect( @json["themes"] ).to eql(@expected["scores"])
              end
            end

            it "returns level names" do
              expect( @json["level_names"] ).to eql( ["Initial", "Repeatable", "Defined", "Managed", "Optimising"] )
            end
          end
        end
      end
    end
  end

  context "when request all organisations by country" do
    factory_create= ->(assessments, users, countries) do
      assessments.each do |assessment|
        next_user = users.shift
        assessment.user_id = next_user.id
        users << next_user
        AssessmentAnswer.create(assessment: assessment, question: Question.first, answer: Answer.find_by_code("Q1.2") )
        assessment.complete if assessment.completion_date
        assessment.save
      end
      if ! countries.empty? then
        users.each do |user|
          next_country = countries.shift
          user.country_id = next_country.id
          countries << next_country
          user.save
        end
      end
    end
    [
      [
        [1, [:assessment], [:organisation_user],[],[]],
        [1, [:assessment], [:user], [],[]],
        [5, [:assessment, :unfinished_assessment] * 2, [:organisation_sequence_user] * 5, [:country2],[]],
        [5, [:unfinished_assessment], [:organisation_sequence_user] * 5, [:country2],[]],
        [2, [:assessment, :unfinished_assessment] * 2, [:organisation_sequence_user] * 5, [:country2],[]],
        [3, [:unfinished_assessment] * 5, [:organisation_sequence_user] * 5, [:country2], [:organisation_user_with_assessments]],
        [1, [:assessment] * 5, [:organisation_sequence_user], [:country2], [:organisation_user_with_assessments]],
        [2, [:unfinished_assessment], [:organisation_sequence_user] * 5, [:country2], [:organisation_user_with_assessments]],
        [3, [:assessment] * 5, [:organisation_sequence_user] * 6, [:country, :country2], [:country_organisation_user_with_assessments]]
      ],
      [
        [["All other countries", 0,0,[0, 0, 0, 0, 0]], ["Not specified", 1,1,[1, 0, 0, 0, 0]]],
        [["All other countries", 0,0,[0, 0, 0, 0, 0]], ["Not specified", 0,0,[0, 0, 0, 0, 0]]],
        [["All other countries", 2,5,[2, 0, 0, 0, 0]], ["Not specified", 0,0,[0, 0, 0, 0, 0]]],
        [["All other countries", 0,5,[0, 0, 0, 0, 0]], ["Not specified", 0,0,[0, 0, 0, 0, 0]]],
        [['Australia',2,5,[2, 0, 0, 0, 0]], ["All other countries", 0,0,[0, 0, 0, 0, 0]], ["Not specified", 0,0,[0, 0, 0, 0, 0]]],
        [["All other countries", 0,5 ,[0, 0, 0, 0, 0]], ["Not specified", 1,1,[1, 0, 0, 0, 0]]],
        [['Australia',1,1,[1, 0, 0, 0, 0]], ["All other countries", 0,0 ,[0, 0, 0, 0, 0]], ["Not specified", 1,1,[1, 0, 0, 0, 0]]],
        [["All other countries", 0,5,[0, 0, 0, 0, 0]], ["Not specified", 1,1,[1, 0, 0, 0, 0]]],
        [['Australia',3,3,[3, 0, 0, 0, 0]], ["All other countries", 3,4,[3, 0, 0, 0, 0]], ["Not specified", 0,0,[0, 0, 0, 0, 0]]]
      ]
    ].transpose.each do |given, data|
      context "given: HEATMAP_THRESHOLD of #{given[0]} for assessments: #{given[1]} answering: #{given[2]} by (#{given[3]}) from #{given[4]} and given: #{given[5]}" do
        before(:each) do
          stub_const("ODMAT::Application::HEATMAP_THRESHOLD", given.shift)
          factories_created = given.collect do |factories|
            factories.collect do |factory|
              FactoryGirl.create(:"#{factory}")
            end
          end
          factory_create.(*factories_created[0..2])
          Organisation.create!(title: "All Organisations")
          Organisation.create!(title: "All data.gov.uk organisations")
          generator = StatisticsGenerator.new
          generator.generate_all
          get "all_organisations_by_country", format: "json"
          expect( response ).to be_success
          @json = JSON.parse(response.body)
          @create_expected_response= -> (*countries,no_country,other) do
            [*countries,no_country,other].collect do | datum |
              { country: datum.shift,
                completed:  datum.shift,
                organisations: datum.shift,
                themes:
                  { "Data management processes":
                    {"Data release process": datum.shift,
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
                     "Asset catalogue":[0, 0, 0, 0, 0]
                   }
                }
              }
            end.as_json << {"level_names"=> ["Initial", "Repeatable", "Defined", "Managed", "Optimising"]}
          end
        end
        context "as json expect #{data}" do
          it "returns all organisations by country" do
            expect(@json).to eql @create_expected_response.(*data)
          end
        end
      end
    end
  end

  context "When requesting country statistics" do
    factory_create= ->(user, assessments) do
      [1,2,3,4,5].each do |count|
         FactoryGirl.create(:"country#{count}")
         FactoryGirl.create(:"organisation#{count}")
         country_user = FactoryGirl.create(user, email: "user#{count}@example.org", country_id: count, organisation_id: count)
         assessments.each do |assessment|
           assessment_created = FactoryGirl.create(assessment, user: country_user)
           AssessmentAnswer.create(assessment: assessment_created, question: Question.first, answer: Answer.find_by_code("Q1.2") )
           assessment.complete
        end
      end
    end
    before(:each) do
      stub_const("ODMAT::Application::HEATMAP_THRESHOLD", 1)
      FactoryGirl.create(:organisation)
      FactoryGirl.create(:user)
      FactoryGirl.create(:admin)
      FactoryGirl.create(:organisation_sequence_user)
      FactoryGirl.create(:country_user)
      FactoryGirl.create(:country_user2)
      FactoryGirl.create(:country_organisation_user_with_assessments)
      Organisation.create!(title: "All Organisations")
      Organisation.create!(title: "All data.gov.uk organisations")
      generator = StatisticsGenerator.new
      generator.generate_all
    end

    context "for country summary data" do
       before(:each) do
          get "summary_by_country", format: "json"
          expect( response ).to be_success
          @json_summary = JSON.parse(response.body)
       end

      it "should return country summary including countries, not specified, and all other countries" do
        expect( @json_summary).to eql(JSON.parse('[{
            "country":"Uruguay",
            "registered_users":1,
            "users_with_organisations":1,
            "assessments":{"completed":5, "total":5},
            "questionnaire_version":1
          },{
            "country":"Not specified",
            "registered_users":3,
            "users_with_organisations":1,
            "assessments":{"completed":0, "total":0},
            "questionnaire_version":1
          },{
            "country":"All other countries",
            "registered_users":2,
            "users_with_organisations":0,
            "assessments":{"completed":0, "total":0},
            "questionnaire_version":1
        }]'))
      end
    end

    context "for all organisations by country" do
      before(:each) do
        get "all_organisations_by_country", format: "json"
        expect( response ).to be_success
        @json_all_orgs = JSON.parse(response.body)
      end

      it "should return all organisations by country, including not specified, and all other countries" do
        expect( @json_all_orgs).to eql(JSON.parse('[
           {"country":"Uruguay",
            "completed":1,
            "organisations":1,
            "themes":
             {"Data management processes":
               {"Data release process":[1, 0, 0, 0, 0],
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
           "organisations":1,
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
         ]'))
      end
    end
  end
end

Feature: Viewing assessment reports

  Background: 
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is completed 

  Scenario: I should see all the tabs
    When I go to "/assessments/1/report"
    Then I should see "Summary"
    And I should see "Maturity scores"
    And I should see "Assessment answers"
    And I should see "Suggested improvements"
    And I should see "Background notes"
    And I should see a link called "Download summary scores" to "/assessments/1/report.csv?style=dimension"
    
  Scenario: I should see the activity scores
    When I go to "/assessments/1/report"
    Then there should be "5" themes in the "activities" section
    And there should be "4" items listed in "#data-management-processes-activities"
    Then the element with id "#data-release-process-score" should have the content "1"      
    And I should see a link called "Download activity scores" to "/assessments/1/report.csv?style=activity" 
            
  Scenario: I should see the report detail
    When I go to "/assessments/1/report"
    Then the element with id "#Q1-text" should have the content "Have you published any open data?"     
    And the element with id "#Q1-answer" should have the content "No, we have not yet published any open data"
    And there should be "4" items listed in "#data-management-processes-detail"

  Scenario: I should see the report improvements
    When I go to "/assessments/1/report"
    Then the element with id "#I1" should have the content "Publish at least one open dataset with an open data certificate"     
    
  Scenario: I should see the report information
    When I go to "/assessments/1/report"
    Then the element with id "#assessor" should have the content "Peter Manion"     
    Then the element with id "#start-date" should have the content "Tuesday, 10th February 2015"   

  Scenario: Obtaining a sharing link
    When I go to "/assessments/1/report"
    Then I should see a link to share the report    
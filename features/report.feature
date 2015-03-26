Feature: Viewing assessment reports

  Scenario: I should see all the tabs
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is completed 
    When I go to "/assessments/1/report"
    Then I should see "Summary"
    And I should see "Activities"
    And I should see "Detail"
    And I should see "Improvements"
    And I should see "Information"
    
  Scenario: I should see the activity scores
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is completed 
    When I go to "/assessments/1/report"
    Then there should be "5" themes in the "activities" section
    And there should be "4" items listed in "#data-management-processes-activities"
    Then the element with id "#data-release-process-score" should have the content "1"      
            
  Scenario: I should see the report detail
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is completed 
    When I go to "/assessments/1/report"
    Then the element with id "#Q1-text" should have the content "Have you published any open data?"     
    And the element with id "#Q1-answer" should have the content "No, we have not yet published any open data"
    And there should be "4" items listed in "#data-management-processes-detail"

  Scenario: I should see the report improvements
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is completed 
    When I go to "/assessments/1/report"
    Then the element with id "#I1" should have the content "Publish at least one open dataset with an open data certificate"     
    
  Scenario: I should see the report information
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is completed 
    When I go to "/assessments/1/report"
    Then the element with id "#assessor" should have the content "Peter Manion"     
    Then the element with id "#start-date" should have the content "Tuesday, 10th February 2015"   
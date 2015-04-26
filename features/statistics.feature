Feature: Statistics page

  Scenario: There are no completed organisational assessments
    Given the test survey has been loaded  
    When I go to "/statistics"
    Then I should see "None of the 0 organisations have completed an assessment"
    
  Scenario: Viewing organisational assessments as an anonymous user
    Given the test survey has been loaded
    Given there is an organisation user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date | user_id | completed |
      | 2014 Q4 | End of last year   | 2014-12-10 11:07:10 |                 | 1       | yes       |
      | 2015 Q1 | Start of year      | 2015-02-10 11:07:10 |                 | 1       | yes       |
    When I go to "/statistics"
    Then I should see "All organisations"
    Then I should see "All data.gov.uk organisations"
    Then I should not see "All in your parent organisation"
    Then I should see "Ratings for all organisations"
    Then I should see "Showing aggregate results for 1 assessment from a total of 1 organisation"
    Then I should see "Data release process"
    Then I should see "100% of organisations scored 1 for Data release process"
        
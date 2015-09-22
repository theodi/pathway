Feature: Sharing reports
  As a user I want to share my reports with other people

  Background:
    Given the test survey has been loaded
    Given there is an organisation user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date | user_id | completed |
      | 2014 Q4 | End of last year   | 2014-12-10 11:07:10 |                 | 1       | yes       |
      | 2015 Q1 | Start of year      | 2015-02-10 11:07:10 |                 | 1       | yes       |

  Scenario: Attempting to view a report when not logged in
    When I go to "/assessments/1/report"
    Then I should see "You are not authorized to access this page."

  Scenario: Attempting to view a report when logged in
    Given I am logged in as a user
    When I go to "/assessments/1/report"
    Then I should see "You are not authorized to access this page."

  Scenario: Attempting to view a report with a token
    When I click on the sharing link for the "2015 Q1" assessment
    Then I should see "Maturity scores"
    Then I should see "Assessment answers"
    Then I should see "Suggested improvements"
    Then I should see "Background notes"
    Then I should not see "Share your report"

  Scenario: Attempting to download a report with a token
    When I click on the sharing link for the "2015 Q1" assessment
    And I click on the link to download summary scores
    Then I should not see "You are not authorized to access this page."
    And I should see a CSV

Feature: Statistics page

  Background:
    Given the test survey has been loaded

  Scenario: There are no completed organisational assessments
    Given the statistics have been generated
    When I go to "/statistics"
    Then I should see "None of the organisations have completed an assessment"

  Scenario: Viewing organisational assessments as an anonymous user
    Given there is an organisation user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date | user_id | completed |
      | 2014 Q4 | End of last year   | 2014-12-10 11:07:10 |                 | 1       | yes       |
      | 2015 Q1 | Start of year      | 2015-02-10 11:07:10 |                 | 1       | yes       |
    Given the statistics have been generated
    When I go to "/statistics"
    Then I should see "All organisations"
    Then I should see "All data.gov.uk organisations"
    Then I should not see "All peer organisations"
    Then I should see "Scores for all organisations"
    Then I should see "Showing aggregate results for 1 assessment from a total of 1 registered users"
    Then I should see "Data release process"
    Then I should see "100% of organisations scored 1 for Data release process"

  Scenario: Viewing organisational assessments as d.g.u organisational user
    Given there is a hierarchy of data.gov.uk organisations
    Given the following assessments:
      | title   | notes              | start_date          | completion_date | user_id | completed |
      | 2014 Q4 | End of last year   | 2014-12-10 11:07:10 |                 | 1       | yes       |
      | 2015 Q1 | Start of year      | 2015-02-10 11:07:10 |                 | 2       | yes       |
    When I am logged in as the forestry commission
    Given the statistics have been generated
    And I go to "/statistics"
    Then I should see "All organisations"
    Then I should see "All data.gov.uk organisations"
    Then I should see "All peer organisations"
    Then I should see "Scores for all organisations"
    Then I should see "Scores for all peer organisations"
    Then I should see "Showing aggregate results for 2 assessments from a total of 2 registered users"
    Then I should see "Data release process"
    Then I should see "100% of organisations scored 1 for Data release process"

  Scenario: There should be a link to the download page
    Given the statistics have been generated
    When I go to "/statistics"
    Then I should see a link called "Download data" to "/statistics/data"

  Scenario: Viewing download statistics page
    Given the statistics have been generated
    When I go to "/statistics/data"
    Then I should see a link called "JSON" to "/statistics/all_organisations.json"
    And I should see a link called "CSV" to "/statistics/all_organisations.csv"
    And I should see a link called "JSON" to "/statistics/all_organisations_by_country.json"
    And I should see a link called "CSV" to "/statistics/all_organisations_by_country.csv"
    And I should see a link called "JSON" to "/statistics/all_dgu_organisations.json"
    And I should see a link called "CSV" to "/statistics/all_dgu_organisations.csv"
    And I should see a link called "JSON" to "/statistics/summary.json"
    And I should see a link called "CSV" to "/statistics/summary.csv"
    And I should see a link called "JSON" to "/statistics/summary_by_country.json"
    And I should see a link called "CSV" to "/statistics/summary_by_country.csv"

Feature: Assessments

  Scenario: Viewing assessments
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
      | 2014 Q3 | Q3 last year       | 2014-12-01 11:07:10 | 2014-12-10 11:07:10 |
      | 2014 Q2 | Q2 last year       | 2014-06-01 11:07:10 | 2014-06-24 11:07:10 |
    When I go to "/assessments"
    Then I should see "2014 Q4"
    And I should see "2014 Q3"
    And I should see "2014 Q2"
    
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
  
  Scenario: Deleting assessments
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
      | 2014 Q3 | Q3 last year       | 2014-12-01 11:07:10 | 2014-12-10 11:07:10 |
      | 2014 Q2 | Q2 last year       | 2014-06-01 11:07:10 | 2014-06-24 11:07:10 |
    When I go to "/assessments"
    And I delete an assessment
    Then I should see "2" assessments

  Scenario: Viewing an assessment
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
      | 2014 Q3 | Q3 last year       | 2014-12-01 11:07:10 | 2014-12-10 11:07:10 |
      | 2014 Q2 | Q2 last year       | 2014-06-01 11:07:10 | 2014-06-24 11:07:10 |
    When I go to "/assessments/1"
    Then I should see "Dimension"
    Then I should see "Activity"

  Scenario: Beginning an assessment
    Given the test survey has been loaded  
    Given I am logged in as a user
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q3 | Q3 last year       | 2014-12-01 11:07:10 | 2014-12-10 11:07:10 |
      | 2014 Q2 | Q2 last year       | 2014-06-01 11:07:10 | 2014-06-24 11:07:10 |
    When I go to "/assessments"
    And I click on "Start an assessment"
    Then I should see "New assessment"

  Scenario: Editing an assessment
    Given the test survey has been loaded
    Given I am logged in as a user
    Given the following assessments:
      | title          | notes              | start_date          | completion_date     |
      | New assessment |                    |                     |                     |
      | 2014 Q3        | Q3 last year       | 2014-12-01 11:07:10 | 2014-12-10 11:07:10 |
    When I go to "/assessments/1/edit"
    And I fill in "assessment_title" with "Q1 Assessment"
    And I fill in "assessment_notes" with "nothing special"
    And I press "Save"
    Then I should see "Q1 Assessment"

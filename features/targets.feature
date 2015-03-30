Feature: Setting targets for future assessments

  Scenario: Navigating to set targets
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have completed an assessment
    When I go to "/assessments"
    Then I should see "Set goals for the next assessment"

  Scenario: Can only set targets when there is a completed assessment
    Given I am logged in as a user
    Given the test survey has been loaded
    Given the following assessments:
      | title   | notes              | start_date          | completion_date     |
      | 2014 Q4 | End of last year   | 2015-02-10 11:07:10 |                     |
    And the current assessment is ready for completion 
    When I go to "/assessments"    
    Then I should not see "Set goals for the next assessment"

  Scenario: Changing targets
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have completed an assessment
    When I go to "/assessments"
    And I click on "Set goals for the next assessment"
    Then I should see "Goal"
    When I fill in "targets_1" with "4"
    And I press "submit-bottom"
    Then I should see "Successfully saved goals"

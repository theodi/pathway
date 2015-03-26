Feature: Setting targets for future assessments

  Scenario: Navigating to set targets
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have completed an assessment
    When I go to "/assessments"
    Then I should see "Set goals for next assessments"

  Scenario: Changing targets
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have completed an assessment
    When I go to "/assessments"
    And I click on "Set goals for next assessments"
    Then I should see "Target Score"
    When I fill in "activity-1-target" with "4"
    And I press "Save goals"
    Then I should see "Successfully saved goals"

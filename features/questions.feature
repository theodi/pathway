Feature: Answering questions

  Scenario: Answering a question positively
    Given I am logged in as a user
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I press "Save"
    Then I should see "Have you released an open data schedule?"
    
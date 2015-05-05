Feature: Answering questions

  Scenario: Answering a question positively
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I press "submit-bottom"
    Then I should see "Do you have a standard dataset release process?"

  Scenario: Answering a question negatively
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "No"
    And I press "submit-bottom"
    Then I should see "Completed assessment"

  Scenario: Navigating back to revise a question
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I press "submit-bottom"
    And I click on "Back"
    Then I should see "Have you published any open data?"

  Scenario: Not allowing a user to navigate back where there was no previous question
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    Then I should not see "Back"

  Scenario: Answering a question and exiting
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I click on "Exit"
    Then I should see "Theme"
    And I should see "Activity"

  Scenario: Not selecting an answer
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I press "submit-bottom"
    Then I should see "Have you published any open data?"
  
  Scenario: Adding a link to a question
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I click on "Add another link"
    Then I should see "Text" 
    And I should see "Link"
  
  Scenario: Using the back button to revise an answer
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I press "submit-bottom"
    Then I should see "Do you have a standard dataset release process?"
    When I go back
    Then I should see "Have you published any open data?"
    When I choose "No"
    And I press "submit-bottom"
    Then I should see "Theme"
    And I should see "Activity"

  @javascript
  Scenario: Removing an existing link
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    Given I have answered the first question including a link
    When I go back to the first question
    And I click on ".delete_association"
    And I press "submit-bottom"
    And I go back to the first question
    Then I should not see "http://www.example.com"

  Scenario: Adding an invalid link to a question
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I fill in "Text" with "Blah"
    And I fill in "Link" with "Blah"
    And I press "submit-bottom"
    Then I should see "link url is an invalid format"

  Scenario: Revising a question for a complete activity
    Given I am logged in as a user
    Given the test survey has been loaded
    Given I have started an assessment
    Given I have completed the first activity
    When I go back to the first question
    And I press "submit-bottom"
    Then I should see "Do you have a standard dataset release process?"
    And I should see "more info on q2"

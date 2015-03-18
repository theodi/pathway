Feature: Answering questions

  Scenario: Answering a question positively
    Given I am logged in as a user
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I press "Save"
    Then I should see "Have you released an open data schedule?"
  
  Scenario: Adding a link to a question
    Given I am logged in as a user
    Given I have started an assessment
    When I go to the first question
    And I choose "Yes"
    And I click on "Add link"
    Then I should see "Text" 
    And I should see "Link"

  @javascript
  Scenario: Removing an existing link
    Given I am logged in as a user
    Given I have started an assessment
    Given I have answered the first question including a link
    When I go back to the first question
    And I click on ".delete_association"
    And I press "Save"
    And I go back to the first question
    Then I should not see "http://www.example.com"

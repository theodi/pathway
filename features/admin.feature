Feature: Administrator Functionality

  Background:
    Given I am logged in as an administrator
    
  Scenario: Viewing the home page as a user
    When I go to the homepage
    Then I should see a link called "Admin" to "/admin"

  Scenario: Viewing the admin page
    Given there is a registered user
    When I go to the homepage
    And I click on "Admin"
    Then I should see "Registered Users"
    And I should see "user@example.org"
    And I should see "admin@example.org"
  
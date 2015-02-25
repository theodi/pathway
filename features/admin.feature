Feature: Administrator

  Background:
    Given I am logged in as an administrator
    
  Scenario: Viewing the home page as a user
    When I go to the homepage
    Then I should see a link called "Admin" to "/admin"

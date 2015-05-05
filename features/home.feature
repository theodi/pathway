Feature: Home page

  Scenario: Viewing the home page
    When I go to the homepage
    And I should see a link called "Privacy policy" to "/privacy-policy"
    And I should see a link called "Cookie policy" to "/cookie-policy"
    And I should see a link called "Terms of use" to "/terms-of-use"
    And I should see a link called "Sign in" to "/users/sign_in"
    And I should see a link called "Register" to "/users/sign_up" 
    And I should see a link called "Statistics" to "/statistics"
    And the page title should read "Open Data Pathway"
    
  Scenario: Viewing the home page as a user
    Given I am logged in as a user
    When I go to the homepage
    And I should see a link called "Sign out" to "/users/sign_out"
    And I should see a link called "Account" to "/users/edit"

  Scenario: Google Analytics
    When I go to the homepage
    Then I should see "UA-XXXX-Y"
    
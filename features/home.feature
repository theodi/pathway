Feature: Home page

  Scenario: Viewing the home page
    When I go to the homepage
    Then I should see a link called "About" to "/about"
    And I should see a link called "Get in touch" to "/contact"
    And I should see a link called "Terms of use" to "/terms"
    And I should see a link called "Login" to "/users/sign_in"
    And I should see a link called "Register" to "/users/sign_up" 

    
Feature: Signing up

  Scenario: Standard sign up
    When I go to the register page
    Then I should see "Register"
    When I fill in "Email" with "test@email.com"
    And I fill in "Name" with "Peter Manion"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I fill in Associated organisation with "British Waterways"
    And I press "Register"
    Then I should see "Welcome! You have signed up successfully."

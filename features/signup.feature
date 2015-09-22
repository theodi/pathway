Feature: Signing up

  Scenario: Standard sign up
    When I go to the register page
    Then I should see "Register"
    When I fill in "Email" with "test@email.com"
    And I fill in "Full name" with "Peter Manion"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I fill in Associated organisation with "British Waterways"
    And I check "user_terms_of_service"
    And I press "Register"
    Then I should see "Welcome! You have signed up successfully."

  Scenario: Sign up without accepting terms
    When I go to the register page
    Then I should see "Register"
    When I fill in "Email" with "test@email.com"
    And I fill in "Full name" with "Peter Manion"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I fill in Associated organisation with "British Waterways"
    And I press "Register"
    Then I should see "Oops - please try again"
    Then I should see "Terms of service must be accepted"

  Scenario: Sign up where organisation has been taken
    Given the test survey has been loaded
    Given a user is already associated with "British Waterways"
    When I go to the register page
    And I fill in "Email" with "alex@email.com"
    And I fill in "Full name" with "Alex Manion"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I fill in Associated organisation with "British Waterways"
    And I press "Register"
    Then I should see "Somebody is already registered as an admin for that organisation"
    And I should see "You can contact them by filling in the following form"
    When I fill in "Your message to the user" with "Hello, can I get access too? Regards, Alex"
    And I press "Submit"
    Then I should see "A message was sent to the admin of British Waterways"

  Scenario: Changing password
    Given I am logged in as a user
    And I visit the user admin page
    And I fill in "Password" with "newpassword"
    And I fill in "Password confirmation" with "newpassword"
    And I fill in "Current password" with "somepassword"
    And I press "Update"
    Then I should see "Your account has been updated successfully"

  Scenario: View assessments after sign-in
    Given I am logged in as a user
    Then I should see "Signed in successfully"
    Then I should see "My assessments"

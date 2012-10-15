Feature: Users
  In order to be aware who is around
  As customer service representative
  I'd like to use in/out board page

  Scenario: User registration
    Given I am on the home page
    And I follow "Sign Up"
    When I fill in the following:
      | Email                 | me@example.com  |
      | First name            | Michael         |
      | Last name             | Jordan          |
      | Password              | 123456          |
      | Password confirmation | 123456          |
    And press "Sign Up"
    And the user "me@example.com" should be created

  Scenario: User login
    Given I am a registered user with following details:
      | Email                 | me@example.com  |
      | First name            | Michael         |
      | Last name             | Jordan          |
      | Password              | 123456          |
      | Password confirmation | 123456          |
    And I am on the home page
    When I fill in the following:
      | Email                 | me@example.com  |
      | Password              | 123456          |
    And press "Log In"
    Then I should be on the board page
    And I should see users list

  @javascript
  Scenario: User change status
    Given I am a logged in user
    And I am on the board page
    When I change my status on "On lunch"
    Then I should see my status on table as "On lunch"


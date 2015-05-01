Feature: login to view application
 
  As a returning or new user
  So that I can view my application
  I want to be able to login or make a new account.

Background: users have been added to database
  
  Given the following users exist: 
  | email          | password 	   |
  | john@gmail.com | 123456789     |

Scenario: returning user logging in
  Given I am on the "login" page
  When I fill in "user_email" with "john@gmail.com"
  And I fill in "user_password" with "123456789"
  When I press "Log in"
  Then I should be on the "profile" page for "john@gmail.com"

Scenario: logging in with invalid username or password
  Given I am on the "login" page
  When I fill in "user_email" with "invalid username"
  And I fill in "user_password" with "12344569112"
  When I press "Log in"
  Then I should be on the "login" page
  And I should see "Invalid email or password"
  
Feature: login to view application
 
  As a returning or new user
  So that I can view my application
  I want to be able to login or make a new account.

Background: users have been added to database
  
  Given the following users exist: 
  | username          | password         | company          | status         |
  | John              | bear             | Whole Foods      | Sponsor        |

Scenario: returning user logging in
  Given I am on the "login" page
  When I fill the "username" box with "John"
  And I fill the "password" box with "bear"
  When I click "login"
  Then I should see the "profile" page

Scenario: logging in with invalid username or password
  Given I am on the "login" page
  When I fill the "username" box with "John"
  And I fill the "password" box with "bare"
  When I click "login"
  Then I should see the "login unsuccessful"

Scenario: create a new account
  Given I am on the "login" page
  When I click "create a new account"
  Then I should see the "registeration" page
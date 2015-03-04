Feature: fill a registeration form to make a new account
 
  As a new user
  So that I can make a new account
  I want to be able to fill a registeration form.

Background: On the registeration page
  
  Given I am on the "registeration" page

Scenario: fill out the form
  When I fill the "username" box with "John"
  And I fill the "password" box with "bear"
  And I fill the "company" box with "Chipolte"
  When I click "continue"
  Then I should see the "questionnaire" page

Scenario: applying for a username that is already taken
  Given the following users exist: 
  | username          | password         | company          | status         |
  | John              | bear             | Whole Foods      | Sponsor        |

  When I fill the "username" box with "John"
  And I fill the "password" box with "bare"
  And I fill the "company" box with "Taco Bell"
  When I click "continue"
  Then I should see "username taken"
  And the "username" box should have "John"
  And the "company" box should have "Taco Bell"

Scenario: any empty boxes returns an error
  When I fill the "username" box with "John"
  And I fill the "password" box with "bare"
  And I fill the "company" box with ""
  When I click "continue"
  Then I should see "company box is empty"
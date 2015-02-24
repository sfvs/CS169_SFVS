Feature: fill a registeration form to make a new account
 
  As a new user
  So that I can make a new account
  I want to be able to fill a registeration form.

Background: movies have been added to database
  
  Given I am on the "registeration" page

Scenario: fill out the form
  When I fill the "username" box with "John"
  And I fill the "company" box with "Chipolte"
  When I click "continue"
  Then I should see the "questionnair" page

Scenario: applying for a username that is already in the database
  Given the following users exist: 
  | username          | company       |
  | John              | Chipolte      |
  # your steps here
  When I fill the "username" box with "John"
  And I fill the "company" box with "Taco Bell"
  When I click "continue"
  Then I should see "username taken"
  And the "username" box should have "John"
  And the "company" box should have "Taco Bell"

Feature: submitting an application
 
  As an avid user
  So that I can complete the application
  I want to be submit my application.

Background: users have been added to database
  
  Given the application is setup
  And user john doe exist in the database
  And the year is "2020"
  And john doe has a 2020 incomplete vendor application
  And john doe has logged in

  Given I am on the "profile" page for "johndoe@gmail.com"

Scenario: submitting an incomplete final application
  When I press "Submit Application"
  Then I should see "Incomplete"

Scenario: submitting with all forms complete
  When john doe has submitted all forms
  And I press "Submit Application"
  Then I should see "Submitted - In Review"
  And I should not see "Click Here to Start Application"
  And I should not see "Submit Application"
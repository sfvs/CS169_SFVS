Feature: view application status and steps to complete application
 
  As an avid user
  So that I can complete the application
  I want to be view my current application status
  and find steps to complete my application.

Background: users have been added to database
  
  Given the application is setup
  And user john doe exist in the database
  And john doe has an incomplete vendor application
  And john doe has logged in

  Given I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  Then I should see my "email" as "johndoe@gmail.com"
  And I should see "vendor"
  And I should see a "button" with id "logout_button"
  And I should see a "button" with id "questionnaire_button"

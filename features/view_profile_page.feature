Feature: view application status and steps to complete application
 
  As an avid user
  So that I can complete the application
  I want to be view my current application status
  and find steps to complete my application.

Background: users have been added to database
  
  Given the application is setup
  And user john doe exist in the database
  And the year is "2020"
  And john doe has a 2020 incomplete vendor application
  And john doe has logged in

  Given I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  Then I should see my "email" as "johndoe@gmail.com"
  And I should see "vendor"
  And I should see "2020"
  And I should see a "button" with id "submit_app_button"
  And I should see a "button" with id "logout_btn"
  And I should see a "button" with id "questionnaire_button"
  And I should see "Incomplete"

Scenario: get a new application for a future year
  Then I should see "2020"
  And I press "logout_btn"
  Given the year is "2024"
  And john doe has logged in
  Then I should see "Click Here to Start Application"
Feature: view application status and steps to complete application
 
  As an avid user
  So that I can complete the application
  I want to be view my current application status
  and find steps to complete my application.

Background: users have been added to database
  
  Given the following users exist: 
  | email             | password         |
  | johndoe@gmail.com | bear12345        |

  Given the following application types exist: 
  | app_type  | id |
  | vendor    | 1  |
  
  Given the following applications exist: 
  | user | type |
  | 1    | 1    |

  Given I login as "johndoe@gmail.com" and password "bear12345"
  And I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  Then I should see my "email" as "johndoe@gmail.com"
  And I should see "vendor"
  And I should see a "button" with id "logout_button"
  And I should see a "button" with id "questionnaire_button"

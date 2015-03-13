Feature: view application status and steps to complete application
 
  As an avid user
  So that I can complete the application
  I want to be view my current application status
  and find steps to complete my application.

Background: users have been added to database
  
  Given the following users exist: 
  | email             | password         |
  | johndoe@gmail.com | bear12345        |

Scenario: view current application status
  Given I am on the "profile" page for "johndoe@gmail.com"
  Then I should see my "email" as "johndoe@gmail.com"
  And I should see my "company" as "company"
  And I should see my "status" as "status"

Scenario: start another form
  Given I am on the "profile" page for "johndoe@gmail.com"
  And I can see "Take Survey"
  When I do follow "Take Survey"
  Then I should see the "survey" page for "johndoe@gmail.com"

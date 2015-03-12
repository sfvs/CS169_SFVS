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
  Given I am on the "profile" page
  Then I should see my "email" as "johndoe@gmail.com"
  And I should see my "company" as "company"
  And I should see my "status" as "status"

Scenario: start another form
  Given I am on the "profile" page
  Then I should see "Health Form"
  When I follow "Health Form"
  Then I should see the "Health Form" page

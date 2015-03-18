Feature: view application status and steps to complete application
 
  As an avid user
  So that I can complete the application
  I want to be view my current application status
  and find steps to complete my application.

Background: users have been added to database
  
  Given the following users exist: 
  | email             | password         |
  | johndoe@gmail.com | bear12345        |
  
  And the following questions exist:
  | question                       | parent_id |
  | Which one came first?          |           |

  And the following answers exist:
  | ans      | questionnaire_id | leads_to |
  | egg      | 1                |  2       |
  | chicken  | 1                |  3       |

  Given I login as "johndoe@gmail.com" and password "bear12345"
  And I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  Then I should see my "email" as "johndoe@gmail.com"
  And I should see my "company" as "company"
  And I should see my "status" as "status"

Scenario: start another form
  Given I should see a "button" with id "questionnaire_button"
  When I press "Take Survey"
  Then I should be on the "survey" page for "johndoe@gmail.com"
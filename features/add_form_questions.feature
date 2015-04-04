Feature: add a form question to the forms
 
  As an admin
  So that I edit the content of forms
  I want to be able to add form questions
  and update the content of the forms.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | admin@gmail.com  | admin123         | true    |
  | admin1@gmail.com | admin123         | true    |
  | admin2@gmail.com | admin123         | true    |

  And a form with questions exists
  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I follow "Forms List"
  And I click on More Information for "General Form"

Scenario: creating a textbox form question
  Given I press "Add Form Question"
  And I am on the creation page for "General Form"
  When I fill in "Enter the question" with "This is a test question"
  And I select "form_question_question_type_textbox"
  And I press "Save Changes"
  Then I should be on the content page for "General Form"
  And I should see "This is a test question"

Scenario: creating a statement form question
  Given I press "Add Form Question"
  And I am on the creation page for "General Form"
  When I fill in "Enter the question" with "This is a test question"
  And I select "form_question_question_type_statement"
  And I press "Save Changes"
  Then I should be on the content page for "General Form"
  And I should see "This is a test question"

Scenario: creating a checkbox form question
  Given I press "Add Form Question"
  And I am on the creation page for "General Form"
  When I fill in "Enter the question" with "This is a test question"
  And I select "form_question_question_type_checkbox"
  And I press "Save Changes"
  Then I should be on the content page for "General Form"
  And I should see "This is a test question"

Scenario: creating a radio button form question
  Given I press "Add Form Question"
  And I am on the creation page for "General Form"
  When I fill in "Enter the question" with "This is a test question"
  And I select "form_question_question_type_radio_button"
  And I press "Save Changes"
  Then I should be on the content page for "General Form"
  And I should see "This is a test question"
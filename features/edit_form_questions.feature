Feature: edit a form question from a form
 
  As an admin
  So that I can manage the forms
  I want to edit the form questions and update the form.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | admin@gmail.com  | admin123         | true    |
  | admin1@gmail.com | admin123         | true    |
  | admin2@gmail.com | admin123         | true    |

  And the "General Form" with questions exists
  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I follow "Forms List"
  And I click on More Information for "General Form"

Scenario: editing a form question
  When I follow "Edit"
  And I erase and fill in "Enter the question" with "Phone Number"
  And I select "form_question_question_type_textbox"
  And I press "Update Form Question"
  Then I should be on the content page for "General Form"
  And I should see "Phone Number"

Scenario: cancelling and returning to previous page
  Given PENDING
  When I follow "Edit"
  And I press "Cancel"
  Then I should be on the content page for "General Form"
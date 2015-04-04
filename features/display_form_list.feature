Feature: display a list of forms and view their contents
 
  As an admin
  So that I can view the forms
  I want to be able to see a list of forms
  and view the content of the forms.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | admin@gmail.com  | admin123         | true    |
  | admin1@gmail.com | admin123         | true    |
  | admin2@gmail.com | admin123         | true    |

  And a form with questions exists
  And I am logged into the admin page as "admin"

Scenario: See a list of forms
  Given I am on the admin profile page
  When I follow "Forms List"
  Then I should see "General Form"

Scenario: clicking on "More Information" next to the form should display its contents
  Given I am on the admin profile page
  When I follow "Forms List"
  And I click on More Info for "General Form"
  Then I should see "General Question"
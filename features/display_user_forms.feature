Feature: view user forms
	
  As an admin
  So that I can manage the users
  I want to view the forms filled by the users.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | user1@gmail.com  | bear12345        | false   |
  | user2@gmail.com  | bear12345        | false   |
  | admin@gmail.com  | admin123         | true    |

  And the "General Form" with questions exists
  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I follow "Users List"

Scenario: display the forms of a user
  Given "user1@gmail.com" has filled the "General Form"
  When I follow "More Info"
  Then I should be on the "edit" page of "user1@gmail.com"
  And I should see "General Form"

Scenario: display the contents of the form of a user
  Given "user1@gmail.com" has filled the "General Form"
  When I follow "More Info"
  And I am on the "edit" page of "user1@gmail.com"
  And I follow "General Form"
  Then I should see "Name" as "Oski"

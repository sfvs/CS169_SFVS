Feature: edit users information
 
  As an admin
  So that I manage the users
  I want to be able edit their company name,
  contact person, and telephone number.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | company_name | contact_person | admin   |
  | user1@gmail.com  | bear12345        | Apple        | Oski           | false   |
  | user2@gmail.com  | bear12345        | Corn         | Cal Bear       | false   |
  | admin@gmail.com  | admin123         |              |                | true    |
  | dog@gmail.com    | dog12345         | Cabbage      | Husky          | false   |
  | cat@gmail.com    | cat12345         | Brocoli      | Persian        | false   |

  And I am logged into the admin page as "admin"
  Given I am on the admin profile page
  When I follow "Users List"

Scenario: successful update should redirect to user content page
	When I click on More Info for "user1@gmail.com"
	And I press "Edit"
	And I erase and fill in "user_company_name" with "Soy"
	And I press "Update User"
	Then I should be on the user content page for "user1@gmail.com"

Scenario: successfully update user information
	When I click on More Info for "user1@gmail.com"
	And I press "Edit"
	And I erase and fill in "user_company_name" with "Soy"
	And I press "Update User"
	And I am on the admin profile page
	When I follow "Users List"
	Then I should see "Soy"
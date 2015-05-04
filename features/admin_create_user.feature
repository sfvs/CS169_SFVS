Feature: create user
 
  As an admin
  So that I can manage users
  I want to be able to create new regular and admin users.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | user1@gmail.com  | bear12345        | false   |
  | user2@gmail.com  | bear12345        | false   |
  | admin@gmail.com  | admin123         | true    |

  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I go to the admin "users" page

Scenario: create a regular user
  Given I follow "Create User"
  And I fill in "Email:" with "new_user@gmail.com"
  And I fill in "Password:" with "user1234"
  And I select "user_admin_false"
  And I press "Create User"
  Then I should be on the users list page
  And I should see "new_user@gmail.com"

Scenario: create an admin
  Given I follow "Create User"
  And I fill in "Email:" with "new_admin@gmail.com"
  And I fill in "Password:" with "admin1234"
  And I select "user_admin_true"
  And I press "Create User"
  Then I should be on the users list page
  And I should see "New user created"
  And I should not see "new_admin@gmail.com"

Scenario: should not be able to use an already existing e-mail
  Given I follow "Create User"
  And I fill in "Email:" with "admin@gmail.com"
  And I fill in "Password:" with "admin1234"
  And I select "user_admin_true"
  And I press "Create User"
  Then I should see "E-mail already taken"

Scenario: should not be able to use a password of length less than 8
  Given I follow "Create User"
  And I fill in "Email:" with "admin123@gmail.com"
  And I fill in "Password:" with "admin"
  And I select "user_admin_true"
  And I press "Create User"
  Then I should see "Password needs to be atleast 8 characters long."
Feature: search user by their e-mail
 
  As an admin
  So that I can view my attendees
  I want to be able to search a user by e-mail
  and find out more about that specific user.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | user1@gmail.com  | bear12345        | false   |
  | user2@gmail.com  | bear12345        | false   |
  | admin@gmail.com  | admin123         | true    |
  | admin1@gmail.com | admin123         | true    |
  | admin2@gmail.com | admin123         | true    |

  And I am logged into the admin page as "admin"
  Given I am on the admin profile page
  When I go to the admin "users" page

Scenario: search user by e-mail
  Given I fill in "Search by e-mail" with "user2@gmail.com"
  And I press "Search"
  Then I should be on the user content page for "user2@gmail.com"

Scenario: invalid e-mail should display an alert message
  Given I fill in "Search by e-mail" with "non@gmail.com"
  And I press "Search"
  Then I should be on the users list page
  And I should see "No user with e-mail: non@gmail.com"

Scenario: admin users should not be able to be searched
  Given I fill in "Search by e-mail" with "admin1@gmail.com"
  And I press "Search"
  Then I should be on the users list page
  And I should see "No user with e-mail: admin1@gmail.com"
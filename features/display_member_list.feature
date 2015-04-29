Feature: display a list of users and view their profiles
 
  As an admin
  So that I can view my attendees
  I want to be able to see a list of users
  and find out more about specific users.

Background: users have been added to database
  
  Given the following users exist: 
  | email            | password         | admin   |
  | user1@gmail.com  | bear12345        | false   |
  | user2@gmail.com  | bear12345        | false   |
  | admin@gmail.com  | admin123         | true    |
  | admin1@gmail.com | admin123         | true    |
  | admin2@gmail.com | admin123         | true    |

  And I am logged into the admin page as "admin"

Scenario: See a list of registered users
  Given I am on the admin profile page
  When I go to the admin "users" page
  Then I should see "user1@gmail.com"
  And I should see "user2@gmail.com"

Scenario: Not see a list of other admins
  Given I am on the admin profile page
  When I go to the admin "users" page
  Then I should not see "admin1@gmail.com"
  And I should not see "admin2@gmail.com"

Scenario: clicking on "More Info" next to the user email should show more information about that user
  Given I am on the admin profile page
  When I go to the admin "users" page
  And I click on More Info for "user1@gmail.com"
  Then I should see "user1@gmail.com"
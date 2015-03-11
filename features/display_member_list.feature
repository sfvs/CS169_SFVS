Feature: display a list of users and view their profiles
 
  As an admin
  So that I can view my attendees
  I want to be able to see a list of users
  and find out more about specific users.

Background: users have been added to database
  
  Given the following users exist: 
  | email             | password         |
  | johndoe@gmail.com | bear12345        |
  | ronpaul@gmail.com | bear12345        |

Scenario: see a list of users
  Given PENDING

Scenario: clicking on a user will show more information about that user
  Given PENDING
  Given I am on the admin "profile" page
  When I follow "John"
  Then I should see the "username" as "John"
  And I should see the "company" as "Whole Foods"
  And I should see the "status" as "Sponsor"


Feature: filter users by application year
 
  As an admin
  So that I can view my attendees
  I want to be able to filters the users by application year
  so that it is easier to manage the users.

Background: application is setup with user john doe
  
  Given application type and forms are setup for vendor and sponsor
  And user john doe exist in the database
  And the year is "2020"
  And john doe has a 2020 incomplete vendor application

  And the following users exist: 
  | email             | password         | admin   |
  | admin@gmail.com   | admin123         | true    |

  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I go to the admin "users" page

Scenario: users should be listed if they have the application for the input year
  Given I fill in "Filter Users by year" with "2020"
  And I press "Filter"
  Then I should see "johndoe@gmail.com"

Scenario: no users should be listed if no one has the application for the input year
  Given I fill in "Filter Users by year" with "1111"
  And I press "Filter"
  Then I should not see "johndoe@gmail.com"
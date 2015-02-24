Feature: display a list of users and view their profiles
 
  As an admin
  So that I can view my attendees
  I want to be able to see a list of users
  and find out more about specific users.

Background: users have been added to database
  
  Given the following users exist: 
  | username          | password         | company          | status         |
  | John              | bear             | Whole Foods      | Sponsor        |
  | Paul              | oski             | Safeway          | Vendor         |

Scenario: see a list of users

Scenario: clicking on a user will show more information about that user
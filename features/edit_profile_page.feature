Feature: view application status and steps to complete application
 
  As a user,
  so that I can change my profile information,
  I should be able to edit my profile.

Background: users have been added to database
  
  Given the application is setup
  And user john doe exist in the database
  And john doe has an incomplete vendor application
  And john doe has logged in

  Given I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  When I press "Edit Profile"
  Then the "user_email" field should contain "johndoe@gmail.com"
  When I fill in "user_email" with "doejohn@gmail.com"
  And I fill in "user_current_password" with "bear12345"
  And I press "Update"
  Then I should be on the "profile" page for "doejohn@gmail.com"
  And I should see "doejohn@gmail.com"
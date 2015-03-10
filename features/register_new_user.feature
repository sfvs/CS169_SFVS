Feature: fill a registeration form to make a new account
 
  As a new user
  So that I can make a new account
  I want to be able to fill a registeration form.

Background: On the registeration page
  
  Given I am on the "registration" page

Scenario: fill out the form
  Given PENDING
  When I fill in "user_email" with "JohnTest@gmail.com"
  And I fill in "user_password" with "bear12345"
  And I fill in "user_password_confirmation" with "bear12345"
  And I press "Sign up"
  Then I should be on the "profile" page for "JohnTest@gmail.com"

Scenario: applying for a username that is already taken
  Given PENDING
  Given the following users exist: 
  | email          | password         |
  | johndoe@gmail.com | bear12345     |

  When I fill in "user_email" with "johndoe@gmail.com"
  And I fill in "user_password" with "bear12345"
  And I fill in "user_password_confirmation" with "bear12345" 
  When I press "Sign up"
  Then I should be on the "registration failed" page
  And I should see "Email has already been taken"

Scenario: any empty boxes returns an error
  Given PENDING
  When I fill in "user_email" with "johndoe@gmail.com"
  #And I fill in "user_password" with ""
  #And I fill in "user_password_confirmation" with "bear12345" 
  When I press "Sign up"
  Then I should be on the "registration failed" page
  And I should see "Password can't be blank"

Feature: edit form for user

As an admin
so that I can change/fix a user's forms
I want to be able to edit the user's forms and resubmit them

Background: users have been added to database
  
  Given application type and forms are setup for vendor and sponsor
  Given the following form questions exist:
  | question                                                         | form_type       | question_type | 
  | Company name                                                     | General Form    | textbox       |
  | Contact person                                                   | General Form    | textbox       |
  | Mailing address                                                  | General Form    | textbox       |
  | City                                                             | General Form    | textbox       |
  | State                                                            | General Form    | textbox       |
  | ZIP                                                              | General Form    | textbox       |
  | Phone                                                            | General Form    | textbox       |
  | Alternate                                                        | General Form    | textbox       |
  | Fax                                                              | General Form    | textbox       |
  | E-mail                                                           | General Form    | textbox       |
  | Website                                                          | General Form    | textbox       |
  | Company name for WVF Program listing (if different from above)   | General Form    | textbox       |

  Given the following users exist: 
  | email             | password         | admin   |
  | johndoe@gmail.com | bear12345        | false   |
  | admin@gmail.com   | admin123         | true    |
  
  And the year is "2020"
  And john doe has a 2020 incomplete vendor application
  And john doe filled the "General Form"
  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  When I go to the edit form page for General Form of "johndoe@gmail.com"

Scenario: Press back
  And I follow "Back"
  Then I should be on the "Application" page for "johndoe@gmail.com"

Scenario: Press Submit without modifying the form
  And I press "Submit"
  Then I should be on the "Application" page for "johndoe@gmail.com"

Scenario: Changing the form
  And I should see "Company name" with "Apple"
  And I type in the following:
  | Company name     | Google  |
  And I press "Submit"
  Then I go to the edit form page for General Form of "johndoe@gmail.com"
  Then I should see "Company name" with "Google"




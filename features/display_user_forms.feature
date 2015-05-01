Feature: view user forms
	
  As an admin
  So that I can manage the users
  I want to view the forms filled by the users.

Background: application is setup with user john doe
  
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

  And user john doe exist in the database
  And the following users exist: 
  | email            | password         | admin   |
  | admin@gmail.com  | admin123         | true    |

  And the year is "2020"
  And john doe has a 2020 incomplete vendor application
  And john doe filled the "General Form"
  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I go to the admin "users" page
  And I follow "View User"
  And I am on the user content page for "johndoe@gmail.com"

Scenario: display the forms of a user
  When I follow "View Application"
  Then I should see "General Form"
  And I should see "Vendor Form"

Scenario: display the questions of the form of a user
  When I follow "View Application"
  And I click the "View Form" button for "General Form"
  Then I should see "Company name"

Scenario: display the content of the form of a user
  When I follow "View Application"
  And I click the "View Form" button for "General Form"
  Then I should see disabled "Company name" with "Apple"

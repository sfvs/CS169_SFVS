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

  And the following users exist: 
  | email            | password         | admin   |
  | johndoe@gmail.com| bear12345        | false   |
  | admin@gmail.com  | admin123         | true    |

  And john doe has an incomplete vendor application
  And I am logged into the admin page as "admin"
  And I am on the admin profile page
  And I follow "Users List"
  And I follow "Show"
  And I am on the user content page for "johndoe@gmail.com"

Scenario: display the forms of a user
  When I follow "Show"
  Then I should see "General Form"
  And I should see "Vendor Form"

Scenario: display the contents of the form of a user
  When I follow "Show"
  And I click the "Show" button for "General Form"
  Then I should see "Company name"

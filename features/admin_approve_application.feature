Feature: approve user application

As an admin
so that I can review users applications
I want to be able approve users applications

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

  And I am logged into the admin page as "admin"
  And I am on the admin profile page

Scenario: approve complete application
  Given john doe has a 2020 complete vendor application
  And I am on the "Application" page for "johndoe@gmail.com"
  When I press "Approve"
  Then I should be on the user content page for "johndoe@gmail.com"
  And I should see "Approved"

Scenario: do not approve incomplete application
  Given john doe has a 2020 incomplete vendor application
  And I am on the "Application" page for "johndoe@gmail.com"
  When I press "Approve"
  Then I should be on the user content page for "johndoe@gmail.com"
  And I should see "Pending"
Feature: view, fill, and submit a form
 
  As an avid user
  So that I can complete the application
  I want to view a required form and
  be able to fill it out for submission.

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
  And john doe has an incomplete vendor application
  And john doe has logged in
  And I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  When I follow General Form
  Then I should be on the "form" page
  And I fill in the following:
  | Company name                                                           | Apple           |
  | Contact person                                                         | Tomato Carrot   |
  | Mailing address                                                        | 4444 Fruit Ave. |
  | City                                                                   | New Pealand     |
  | State                                                                  | AA              |
  | ZIP                                                                    | 12345           |
  | Phone                                                                  | 111-222-3333    |
  | Alternate                                                              | 333-222-1111    |
  | Fax                                                                    | 222-111-5555    |
  | E-mail                                                                 | green@onion.com |
  | Website                                                                | apple.com       |
  | Company name for WVF Program listing (if different from above)         | Microsoft       |   
  When I follow "Submit Form"
  Then I should be on the "profile" page for "johndoe@gmail.com"
  And I should see completed for "general form"
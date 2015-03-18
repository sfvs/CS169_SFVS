Feature: view, fill, and submit the general form
 
  As an avid user
  So that I can complete the application
  I want to be view the general form and
  be able to fill it out for submission.

Background: users have been added to database
  
  Given the following users exist: 
  | email             | password         |
  | johndoe@gmail.com | bear12345        |

  Given I login as "johndoe@gmail.com" and password "bear12345"
  And I am on the "profile" page for "johndoe@gmail.com"

Scenario: view current application status
  When I follow general_form
  Then I should be on the "general_form" page
  And I fill in the following:
  | Company name      | Apple           |
  | Contact person    | Tomato Carrot   |
  | Mailing address   | 4444 Fruit Ave. |
  | City              | New Pealand     |
  | State             | AA              |
  | ZIP               | 12345           |
  | Phone             | 111-222-3333    |
  | Alternate         | 333-222-1111    |
  | Fax               | 222-111-5555    |
  | E-mail            | green@onion.com |
  | Website           | apple.com       |
  | Company name for WVF Program listing (if different from above) | Microsoft |
  When I press "submit_button"
  Then I should be on the "profile" page for "johndoe@gmail.com"
  And I should see completed for "general_form"
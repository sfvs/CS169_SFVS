Feature: fill a questionnaire form to find type of attendee
 
  As a new user
  So that I can find out what attendee type I am
  I want to be able to fill a questionnair form.

Background: on the questionnaire form
  
  Given the following users exist: 
  | email             | password         |
  | johndoe@gmail.com | bear12345        |

  Given the following application types exist: 
  | app_type  | id |
  | vendor    | 1  |
  | sponsor   | 2  |


  And the following questions exist:
  | question                       | parent_id |
  | Which one came first?          |           |
  | How do you like your veggies?  | 1         |
  | Which is your favorite veggie? | 1         |

  And the following answers exist:
  | ans      | questionnaire_id | leads_to | results_to |
  | egg      | 1                |  2       |            |
  | chicken  | 1                |  3       |            |
  | sauteed  | 2                |          | 1          |
  | zuccini  | 3                |          | 2          |
  | raw      | 2                |          | 1          |
  | cucumber | 3                |          | 2          |

  Given I login as "johndoe@gmail.com" and password "bear12345"
  And I am on the "profile" page for "johndoe@gmail.com"

Scenario: selecting an answer
  When I press "Take Survey"
  Then I should see "Which one came first?"
  And I should see "egg"
  And I should see "chicken"
  When I follow "egg"
  Then I should see "How do you like your veggies?"
  And I should see "egg" selected
  And I should see "raw"
  And I should see "sauteed"

Scenario: completing the questionnaire
  When I press "Take Survey"
  And I follow "chicken"
  Then I should see "chicken" selected
  When I follow "zuccini"
  Then I should see "chicken" selected
  And I should see "zuccini" selected
  When I follow "Submit Questionnaire"
  Then I should be on the "profile" page for "johndoe@gmail.com"
  And I should see "sponsor."

Feature: fill a questionnaire form to find type of attendee
 
  As a new user
  So that I can find out what attendee type I am
  I want to be able to fill a questionnair form.

Background: on the questionnaire form
  
  Given user john doe exist in the database

  And the following application types exist: 
  | app_type  | id |
  | vendor    | 1  |
  | sponsor   | 2  |

  And the following survey questions exist:
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

  And john doe has logged in
  And I am on the "profile" page for "johndoe@gmail.com"
  Given I press "Click Here to Start Application"

Scenario: selecting an answer
  Then I should see "Which one came first?"
  And I should see "egg"
  And I should see "chicken"
  When I follow "egg"
  Then I should see "How do you like your veggies?"
  And I should see "egg" selected
  And I should see "raw"
  And I should see "sauteed"

Scenario: completing the questionnaire
  And I follow "chicken"
  Then I should see "chicken" selected
  When I follow "zuccini"
  Then I should see "chicken" selected
  And I should see "zuccini" selected
  When I press "Fill up Questionaire Form"
  Then I should be on the "profile" page for "johndoe@gmail.com"
  And I should see "sponsor."

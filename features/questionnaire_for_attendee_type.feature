Feature: fill a questionnaire form to find type of attendee
 
  As a new user
  So that I can find out what attendee type I am
  I want to be able to fill a questionnair form.

Background: on the questionnaire form
  
Scenario: User is a vendor
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "yes" to "Will you be selling products?"
  And I answer "no" to "Will you also money to SFVS?"
  Then I should see "You are a vendor"
  
Scenario: User is a vendor/sponsor
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "yes" to "Will you be selling products?"
  And I answer "yes" to "Will you also donate to SFVS?"
  Then I should see "You are a vendor/sponsor"
 
Scenario: User is a non-profit
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Will you be selling products?"
  And I answer "yes" to "Will you be giving away free products AND are a non-profit?"
  And I answer "no" to "Will you also donate to SFVS?"
  Then I should see "You are a non-profit"
 
Scenario: User is a non-profit/sponsor
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Will you be selling products?"
  And I answer "yes" to "Will you be giving away free products AND are a non-profit?"
  And I answer "yes" to "Will you also donate to SFVS?"
  Then I should see "You are a non-profit/sponsor"
 
Scenario: User is a regular exhibitor (i.e. cliff bars trying to promote their product)
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Am I selling products?"
  And I answer "no" to "Will you be selling products?"
  And I answer "no" to "Will you be giving away free products AND are a non-profit?"
  And I answer "yes" to "Will you be giving away free products AND are NOT a non-profit?"
  And I answer "no" to "Will you also donate to SFVS?"
  Then I should see "You are a regular exhibitor"
 
Scenario: User is a regular exhibitor/sponsor (i.e. cliff bars trying to promote their product)
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Am I selling products?"
  And I answer "no" to "Will you be selling products?"
  And I answer "no" to "Will you be giving away free products AND are a non-profit?"
  And I answer "yes" to "Will you be giving away free products AND are NOT a non-profit?"
  And I answer "yes" to "Will you also donate to SFVS?"
  Then I should see "You are a regular exhibitor/sponsor"
 
Scenario: User is a sponsor only with a table
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Am I selling products?"
  And I answer "no" to "Will you be selling products?"
  And I answer "no" to "Will you be giving away free products AND are a non-profit?"
  And I answer "no" to "Will you be giving away free products AND are NOT a non-profit?"
  And I answer "yes" to "Will you be requiring a table?"
  And I answer "yes" to "Will you also donate to SFVS?"
  Then I should see "You are a sponsor requiring a table"
 
Scenario: User is a sponsor only without a table
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Am I selling products?"
  And I answer "no" to "Will you be selling products?"
  And I answer "no" to "Will you be giving away free products AND are a non-profit?"
  And I answer "no" to "Will you be giving away free products AND are NOT a non-profit?"
  And I answer "no" to "Will you be requiring a table?"
  And I answer "yes" to "Will you also donating to SFVS?"
  Then I should see "You are a sponsor"
 
Scenario: User is a regular exhibitor (because they fall under "all other" categories)
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Am I selling products?"
  And I answer "no" to "Will you be selling products?"
  And I answer "no" to "Will you be giving away free products AND are a non-profit?"
  And I answer "no" to "Will you be giving away free products AND are NOT a non-profit?"
  And I answer "yes" to "Will you be requiring a table?"
  And I answer "no" to "Will you also donate to SFVS?"
  Then I should see "You are a regular exhibitor"
 
Scenario: User is unknown...
  Given PENDING
  Given I am on the "questionnaire" page
  When I answer "no" to "Am I selling products?"
  And I answer "no" to "Will you be selling products?"
  And I answer "no" to "Will you be giving away free products AND are a non-profit?"
  And I answer "no" to "Will you be giving away free products AND are NOT a non-profit?"
  And I answer "no" to "Will you be requiring a table?"
  And I answer "no" to "Will you also donate to SFVS?"
  Then I should see "Please call or email us to help you determine the type of attendee you should register as."

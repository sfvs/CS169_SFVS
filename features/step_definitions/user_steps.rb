# user steps
Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(user, :without_protection => true)
  end
end

Given(/^the application is setup$/) do
  steps %Q{
    Given application type and forms are setup for vendor and sponsor 

    And the following survey questions exist:
    | question                       | parent_id |
    | What type of Exhibitor are you?|           |

    And the following answers exist:
    | ans           | questionnaire_id | results_to |
    | vendor        | 1                | 1          |
    | sponsor       | 1                | 2          |
    | non-profit    | 1                | 3          |
    | other vendor  | 1                | 4          |
  }
end

# user profile steps
Then(/^I should see my "email" as "(.*)"$/) do |email|
  assert page.has_content?("#{email}")
end 

Then(/^I should see a "(.*)" with id "(.*)"$/) do |item,id|
  assert find("#"+id)
end
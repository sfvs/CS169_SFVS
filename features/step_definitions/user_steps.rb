# user profile steps
Then(/^I should see my "email" as "(.*)"$/) do |email|
  assert page.has_content?("#{email}")
end 

And(/^I should see my "company" as "(.*)"$/) do |company|
  assert page.has_content?("#{company}")
end

And(/^I should see my "status" as "(.*)"$/) do |status|
  assert page.has_content?("#{status}")
end

# questionnaire steps
Then(/^I should see "(.*)" selected$/) do |answer|
  assert find_link(answer)['class'] == 'selected'
end

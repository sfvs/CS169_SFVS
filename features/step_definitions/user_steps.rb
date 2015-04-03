# user profile steps
Then(/^I should see my "email" as "(.*)"$/) do |email|
  assert page.has_content?("#{email}")
end 

# questionnaire steps
Then(/^I should see "(.*)" selected$/) do |answer|
  assert find_link(answer)['class'] == 'selected'
end

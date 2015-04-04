# questionnaire steps
Given(/^the following survey questions exist:$/) do |table|
  table.hashes.each do |item|
    # take note that id does not get assigned
    # it is there to help find the parsed status
    Questionnaire.create(item)
  end
end

Given(/^the following answers exist:$/) do |table|
  table.hashes.each do |item|
    Answers.create(item)
  end
end

Then(/^I should see "(.*)" selected$/) do |answer|
  assert find_link(answer)['class'] == 'selected'
end


# Step to make a scenerio pending.
Given /^PENDING/ do
  pending
end

Given(/^I login as "(.*)" and password "(.*)"$/) do |email, password|
  step "I am on the \"login\" page"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end

Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(user, :without_protection => true)
  end
end

Given(/^the following questions exist:$/) do |table|
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

Then(/^I should see a "(.*)" with id "(.*)"$/) do |item,id|
  assert find("#"+id)
end

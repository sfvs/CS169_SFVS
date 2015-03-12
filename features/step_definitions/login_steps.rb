# login steps
Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(user, :without_protection => true)
  end

=begin
Given(/^I am on the 'profile' page$/) do
	visit edit_user_path
end

Then(/^I should see my "email" as "johndoe@gmail.com"$/) do
	assert page.has_content?("#{user.email}")
end 

And(/^I should see my "company" as "company"$/) do
	assert page.has_content?("company")
end

And(/^I should see my "status" as "status"$/) do
	assert page.has_content?("status")
end

Then(/^I should see my "Health Form"$/) do
	assert page.has_content?("Health Form")
end 

When(/^I follow "Health Form"$/) do
	click_link("Health Form")
end 

Then(/^I should see the "Health Form" page$/) do
	assert page.has_content("Health Form")
end 
=end 
end
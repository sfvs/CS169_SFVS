# login steps
Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(user, :without_protection => true)
  end
end 

Then(/^I should see my "email" as "(.*)"$/) do |email|
	fill_in "user_email", :with => email
	fill_in "user_password", :with => "bear12345"
	click_button "Log in"
	assert page.has_content?("#{email}")
end 

And(/^I should see my "company" as "(.*)"$/) do |company|
	assert page.has_content?("#{company}")
end

And(/^I should see my "status" as "(.*)"$/) do |status|
	assert page.has_content?("#{status}")
end

And(/^I can see "(.*)"$/) do |survey|
	fill_in "user_email", :with => "johndoe@gmail.com"
	fill_in "user_password", :with => "bear12345"
	click_button "Log in"
	should have_button "Take Survey"
end 

When(/^I do follow "(.*)"$/)  do |survey|
	questions = [{:question => 'Which one came first?'},
			 {:question => 'How do you like it?', :parent_id => 1},
			 {:question => 'which part of chicken do you like?', :parent_id => 1}]

    questions.each do |q|
		Questionnaire.create!(q)
	end
	click_button("#{survey}")
end 

Then(/^I should see the "survey" page for "(.*)"$/) do |email|
	assert page.has_content?("Questionnaire")
end 
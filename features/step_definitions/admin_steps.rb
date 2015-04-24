And /^I am logged into the admin page as "(.*)"$/ do |user|
  visit '/member/sign_in'
  case user
  when "admin"
    fill_in 'user_email', :with => 'admin@gmail.com'
    fill_in 'user_password', :with => 'admin123'
    click_button 'Log in'
  when "user"
    fill_in 'user_email', :with => 'user1@gmail.com'
    fill_in 'user_password', :with => 'bear12345'
    click_button 'Log in'
  end
end

When /^I click on More Info for "(.*)"$/ do |user_email|
  user = User.find(:first, :conditions => [ "email = ?", user_email])
  xpath_search = "///a[@href='/admin/users/" + user.id.to_s + "']"
  find(:xpath, xpath_search).click
end

And /^the "(.*?)" with questions exists$/ do |form_name|
  gen = Form.create({:form_name => form_name})
  gen.form_questions.create({:question => "General Question", :question_type => "textbox", :order => 1})
end

And /^I click on More Information for "(.*)"$/ do |form_name|
  form = Form.find(:first, :conditions => ["form_name = ?", form_name])
  xpath_search = "///a[@href='/admin/forms/" + form.id.to_s + "/form_questions']"
  find(:xpath, xpath_search).click
end

And /^I select "(.*)"$/ do |radio_id|
  choose radio_id
end

When(/^I erase and fill in "(.*?)" with "(.*?)"$/) do |question, new_question|
  fill_in(question, :with => "")
  fill_in(question, :with => new_question)
end

When(/^I click the "(.*?)" button for "(.*?)"$/) do |button, form_name|
  visit "1/form?form_type=" + form_name.gsub(' ','+')
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # ensure that that e1 occurs before e2.
  # page.body is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  match = regexp =~ page.body
  assert_match regexp, page.body
end

Then(/^users should be sorted by "(.*)":$/) do |order, table|
  count = 0
  previous_user = nil
  table.hashes.each do |item|
    if count > 0
      step %Q{I should see "#{previous_user}" before "#{item[order]}"}
    end
    previous_user = item[order]
    count += 1 
  end
end

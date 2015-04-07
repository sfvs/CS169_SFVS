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
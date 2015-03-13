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
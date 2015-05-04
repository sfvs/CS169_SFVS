require 'timecop'

# Step to make a scenerio pending.
Given /^PENDING/ do
  pending
end

Given(/^the year is "(.*)"/) do |time|
  Timecop.freeze(Time.local(time))
  Application.current_application_year = Time.now.year
end

Given(/^the following application types exist:$/) do |table|
  table.hashes.each do |item|
    ApplicationType.create(item)
  end
end

Given(/^the following applications exist:$/) do |table|
  table.hashes.each do |item|
    app = Application.create(item,:without_protection => true)
  end
end

Given(/^application type and forms are setup for vendor and sponsor$/) do
  # create application types
  vendor = ApplicationType.create({:app_type => 'vendor'})
  sponsor = ApplicationType.create({:app_type => 'sponsor'})

  # create forms
  general_form = Form.create({:form_name => "General Form"})
  vendor_form = Form.create({:form_name => "Vendor Form"})
  sponsor_form = Form.create({:form_name => "Sponsor Form"})

  # create relation
  vendor.forms << [general_form,vendor_form]
  sponsor.forms << [general_form,sponsor_form]
end

Given(/^user john doe exist in the database$/) do
  steps %Q{
    Given the following users exist: 
    | email             | password         |
    | johndoe@gmail.com | bear12345        |
  }
end

Given(/^john doe has a 2020 incomplete vendor application$/) do
  steps %Q{
    Given the following applications exist: 
    | user_id | application_type_id | completed | year |
    | 1       | 1                   | false     | 2020 |
  }
end

Given(/^john doe has a 2020 complete vendor application$/) do
  steps %Q{
    Given the following applications exist: 
    | user_id | application_type_id | completed | year | has_paid |
    | 1       | 1                   | true      | 2020 | true     |
  }
end

Given(/^john doe has submitted all forms$/) do
  steps %Q{
    When I follow "General Form"  
    And I press "Submit"
    When I follow "Vendor Form"  
    And I press "Submit"
  }
end

Given(/^john doe has logged in$/) do
  steps %Q{
    Given I login as "johndoe@gmail.com" and password "bear12345"
  }
end

Given(/^I login as "(.*)" and password "(.*)"$/) do |email, password|
  step "I am on the \"login\" page"
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end


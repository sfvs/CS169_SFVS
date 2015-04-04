# form_question step
Given(/^the following form questions exist:$/) do |table|
  table.hashes.each do |item|
    app = FormQuestion.create(item,:without_protection => true)
  end
end

Given(/^user john doe exist in the database$/) do
  steps %Q{
    Given the following users exist: 
    | email             | password         |
    | johndoe@gmail.com | bear12345        |
  }
end
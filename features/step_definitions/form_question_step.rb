# form_question step
Given(/^the following form questions exist:$/) do |table|
  order = 1
  table.hashes.each do |item|
	app = Form.find_by_form_name(item[:form_type])
    item[:order] = order
    app.form_questions << FormQuestion.create(item,:without_protection => true)
    order += 1
  end
end

Then(/^I type in the following:$/) do |table|
  order = 0
  table.rows_hash.each do |name, value|
    fill_in 'form_answer[' + order.to_s + ']', :with => value 
    order += 1
  end
end

Then(/^I should see "(.*?)" with "(.*?)"$/) do |field_name, value|
  order = FormQuestion.where(question: field_name).first.order
  find_field('form_answer[' + (order - 1).to_s + ']').value.should eq value
end

Given(/^john doe filled the "(.*?)"$/) do |form|
  steps %Q{
    Given john doe has logged in
    And I am on the "profile" page for "johndoe@gmail.com"
    When I follow "General Form"
    Then I should be on the "General Form" form page for "johndoe@gmail.com"
    And I type in the following:
    | Company name                                                           | Apple           |
    | Contact person                                                         | Tomato Carrot   |
    | Mailing address                                                        | 4444 Fruit Ave. |
    | City                                                                   | New Pealand     |
    | State                                                                  | AA              |
    | ZIP                                                                    | 12345           |
    | Phone                                                                  | 111-222-3333    |
    | Alternate                                                              | 333-222-1111    |
    | Fax                                                                    | 222-111-5555    |
    | E-mail                                                                 | green@onion.com |
    | Website                                                                | apple.com       |
    | Company name for WVF Program listing (if different from above)         | Microsoft       |   
    When I press "Save and Return"
    And I should see "General Form successfully saved."
    And I press "Logout"
  }
end

When(/^I fill out the form completely$/) do
  steps %Q{
    And I type in the following:
    | Company name                                                   | Apple           |
    | Contact person                                                 | Tomato Carrot   |
    | Mailing address                                                | 4444 Fruit Ave. |
    | City                                                           | New Pealand     |
    | State                                                          | AA              |
    | ZIP                                                            | 12345           |
    | Phone                                                          | 111-222-3333    |
    | Alternate                                                      | 333-222-1111    |
    | Fax                                                            | 222-111-5555    |
    | E-mail                                                         | green@onion.com |
    | Website                                                        | apple.com       |
    | Company name for WVF Program listing (if different from above) | Microsoft       |
  }
end

Then(/^I should see disabled "(.*?)" with "(.*?)"$/) do |field_name, value|
  order = FormQuestion.where(question: field_name).first.order
  field_labeled('form_answer[' + (order - 1).to_s + ']', disabled: true).has_content? value
end

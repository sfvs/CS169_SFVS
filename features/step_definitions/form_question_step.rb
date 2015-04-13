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
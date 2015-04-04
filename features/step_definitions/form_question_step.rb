# form_question step
Given(/^the following form questions exist:$/) do |table|
  table.hashes.each do |item|
	app = Form.find_by_form_name(item[:form_type])
    app.form_questions << FormQuestion.create(item,:without_protection => true)
  end
end


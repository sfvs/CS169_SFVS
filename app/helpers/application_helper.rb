module ApplicationHelper
  def body_class(class_name="default_class")
    content_for :body_class, class_name
  end

  def get_answers_to_prefill_from(content, form_type)
    number_of_questions = Form.where("form_name=?", form_type).first.number_of_questions
    form_answer = Hash.new
    cur_num_questions = 0
    content.each do |key, value|
      if cur_num_questions != number_of_questions && key != "completed"
        form_answer[cur_num_questions.to_s] = value
        cur_num_questions += 1
      end
    end
    form_answer
  end

  def form_completed?(form_content, form_name)
    index = 0
    ordered_list_of_questions = Form.where("form_name=?", form_name).first.get_sorted_form_questions
    form_content[form_name].each do |question, value|
      if form_content[form_name].has_value?("") || form_content[form_name].has_value?(nil)
        if ordered_list_of_questions[index].question_type != "message" && ordered_list_of_questions[index].question_type != "statement"
          return false if value == nil || value == ""
        end
      end
      index += 1
    end 
    return true
  end
end

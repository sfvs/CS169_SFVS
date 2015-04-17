module ApplicationHelper
  def body_class(class_name="default_class")
    content_for :body_class, class_name
  end

  def get_answers_to_prefill_from(content, form_type)
    number_of_questions = Form.where(form_name: form_type)[0].number_of_questions
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
end

module FormQuestionHelper
    # Form an array of answers using the params
  def get_answers(form_answers, form)
    answers_list = []
    num_questions = form.number_of_questions
    (0..(num_questions - 1)).each do |index|
      if form_answers.nil?
        answers_list[index] = nil
      else
        answers_list[index] = form_answers.has_key?(index.to_s) ? form_answers[index.to_s] : nil
      end
    end
    answers_list
  end

  def get_form_content(form, form_answers)
    @questions_list = form.get_sorted_form_questions
    form_content = {
      form.form_name => Hash.new
    }
    answer_list = get_answers(form_answers, form)
    index = 0
    @questions_list.each do |question|
      if question.question_type == "statement"
        form_content[form.form_name][question.question] = "No Answer Required For Statement Questions"
      else
        form_content[form.form_name][question.question] = answer_list[index]
      end
      index += 1
    end
    form_content
  end
end

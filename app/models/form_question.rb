class FormQuestion < ActiveRecord::Base
  attr_accessible :question, :answers, :form_type, :question_type, :order
  belongs_to :form

  before_save :sanitize_input

  def self.get_form_question_types
    [:checkbox, :textbox, :radio_button, :statement, :message]
  end

  private

  def sanitize_input
    # filter double quotes as it causes problems when parsing json in Application.content
    unless self.question.nil?
      self.question = self.question.gsub(/"/, '')
    end
    unless self.answers.nil?
      self.answers = self.answers.gsub(/"/, '')
    end
  end

end

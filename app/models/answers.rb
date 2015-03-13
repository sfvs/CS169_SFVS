class Answers < ActiveRecord::Base
  attr_accessible :ans, :questionnaire_id, :leads_to
  belongs_to :questionnaire

  def self.get_answer_leading_to(question)
      self.where(questionnaire_id: question.parent_id, leads_to: question.id)[0]
  end

  def self.get_answer_from(question)
    self.where(questionnaire_id: question.id)
  end

end
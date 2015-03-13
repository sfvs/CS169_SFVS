class Answers < ActiveRecord::Base
  attr_accessible :ans, :questionnaire_id, :leads_to
  belongs_to :questionnaire

  def self.get_answer_id(question)
  	return Answers.where(questionnaire_id: question.parent_id, leads_to: question.id)[0].id
  end

  def self.get_answer_from_question q
  	self.where(questionnaire_id: q.id)
  end

end
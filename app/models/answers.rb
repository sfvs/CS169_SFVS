class Answers < ActiveRecord::Base
  attr_accessible :ans, :questionnaire_id, :leads_to
  belongs_to :questionnaire

  def Answers.get_answer_id(qid, pid)
  	return Answers.where(questionnaire_id: pid, leads_to: qid)[0].id
  end
end
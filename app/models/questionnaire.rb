class Questionnaire < ActiveRecord::Base
  attr_accessible :parent_id, :question

  def self.get_root_question_id
  	1 #should actually get root instead of hard code
  end

end
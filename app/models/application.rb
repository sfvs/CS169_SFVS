class Application < ActiveRecord::Base
  attr_accessible :user, :year, :type, :content, :completed

  def self.get_application_types
  	application_types = {}
  	application_types[:vendor] = Answers.find_by_ans(:Vendor).id.to_s
  	application_types[:donor] = Answers.find_by_ans(:Donor).id.to_s
  	application_types[:restaurant_concessionaire] = Answers.find_by_ans(:Restaurant_Concessionaire).id.to_s
  	application_types[:other] = Answers.find_by_ans(:Other).id.to_s
  	application_types
  end

end

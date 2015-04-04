require 'json'

class Application < ActiveRecord::Base	
  attr_accessible :year, :content, :completed
  belongs_to :user
  belongs_to :application_type

	def content
		# has content been parsed yet? If not, let's do that..
		if not @hashed_val
			val = read_attribute(:content)
			if (val == "")
				@hashed_val = {}
			else
				@hashed_val = JSON.parse(read_attribute(:content))
			end
		end

		return @hashed_val
	end

	def content=(val)
		@hashed_val = JSON.parse(val.to_json)
		#print(val.to_json)
		write_attribute(:content, val.to_json)
		#self.update_attributes(:content => val.to_json)
	end
end

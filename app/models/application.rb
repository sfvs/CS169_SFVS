require 'json'

class Application < ActiveRecord::Base	
  attr_accessible :year, :content, :completed
  belongs_to :user
  belongs_to :application_type

  def self.current_application_year
    Time.now.year
  end

  def content
  	# has content been parsed yet? If not, let's do that..
    if not @hashed_val
      val = read_attribute(:content)
      if (val == "" or val == nil)
        @hashed_val = {}
      else
        @hashed_val = JSON.parse(read_attribute(:content).gsub('\"', '"'))
      end
    end
  
    return @hashed_val
  end

  def content=(val)
    if val == nil
      @hashed_val = {}
    else
      @hashed_val = JSON.parse(val.to_json)
      write_attribute(:content, val.to_json)
    end
  end

  def add_content(form_content_hash)
    self.content = self.content.merge(form_content_hash)
    self.save!
  end
end

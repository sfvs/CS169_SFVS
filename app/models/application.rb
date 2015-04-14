require 'json'

class Application < ActiveRecord::Base	
  attr_accessible :year, :content, :completed
  belongs_to :user
  belongs_to :application_type

  @@year = 2015
  def self.latest_year
    @@year
  end

  def self.latest_year=(year)
    @@year=year
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

  def get_form(form_name)
    form = Form.where(form_name: form_name).first
    form.get_sorted_form_questions
    form
  end
end

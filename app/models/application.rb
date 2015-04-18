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

  def get_form(form_name)
    form = Form.where(form_name: form_name).first
    form.get_sorted_form_questions
    form
  end

  def get_forms
    self.application_type.forms
  end

  def get_completed_forms
    # Hash, key name of form and value (true, false) depending on completed
    completed_forms = Hash.new
    self.content.each do |key, value|
      completed_forms[key] = value["completed"] == true ? true : false
    end
    completed_forms
  end

end

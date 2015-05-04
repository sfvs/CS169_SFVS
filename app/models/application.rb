require 'json'

class Application < ActiveRecord::Base  
  attr_accessible :year, :content, :completed, :approved, :submitted_at,
    :amount_paid, :amount_due, :has_paid, :pay_receipt, :pay_status, :invoice_number, :payment_id
  belongs_to :user
  belongs_to :application_type
  has_many :file_attachments, dependent: :destroy

  PAYSTATUS_UNPAID = 0
  PAYSTATUS_PENDING = 1
  PAYSTATUS_PAID = 2
  PAYSTATUS_DECLINED = 3

  class << self
    attr_accessor :current_application_year
  end

  self.current_application_year = Time.now.year

  def completition_status
    if self.approved
      status = "Complete"
    elsif self.completed
      status = "Submitted - In Review"
    else
      status = "Incomplete"
    end
    status
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
    form = Form.where("form_name=?", form_name).first
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

  def all_forms_completed?
    completed_forms = self.get_completed_forms
    return false if completed_forms.length != self.application_type.forms.length    
    completed_forms.each_value do |value|
      return value if value == false
    end
    true
  end

  def update_application(completed, form_content, form_name)
    form_content[form_name].update(self.sanitize_form_content(form_name, form_content[form_name]))
    form_content[form_name][:completed] = completed
    self.add_content(form_content)
  end

  def sanitize_form_content(form_name, form_contents_actual)
    # remove quotes for Json parsing, and removed parenthesis for payment calculation.
    form = Form.find_by_form_name(form_name)
    text_questions = form.form_questions.where(:question_type => [:message,:textbox])
    text_questions.each do |form_question|
      form_contents_actual[form_question.question].gsub!(/["$]/, '')
    end
    form_contents_actual
  end

  def grab_application_cost_description
    # regex everything in the format ($## word). ex ($75 electricity fee)
    read_attribute(:content).scan(/\((\$[[:digit:]]+) ([[[:digit:]][[:alpha:]][[:space:]]]+)\)/i)
  end

  def calculate_current_application_cost all_costs
    cost_list = all_costs.map { |cost,item| cost }
    amount_to_be_paid = cost_list.map{ |price| price.match(/[[:digit:]]+/)[0].to_i }
    self.amount_due = amount_to_be_paid.sum
    self.save
  end

  def hasPaid?
    return read_attribute(:has_paid)
  end

  def pay_status_string
    payment_status = {
      PAYSTATUS_UNPAID =>"Not Paid",
      PAYSTATUS_PENDING => "Pending",
      PAYSTATUS_PAID => "Paid",
      PAYSTATUS_DECLINED => "Declined",
    }
    payment_status[read_attribute(:pay_status)]
  end

  def save_file incoming_file, type
    attachment = self.file_attachments.find_by_file_type(type)
    if attachment.nil?
      attachment = self.file_attachments.build
      attachment.file_type = type
    end

    attachment.uploaded_file = incoming_file
    attachment.save
  end
end

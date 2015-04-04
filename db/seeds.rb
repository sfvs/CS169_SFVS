# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_a_user(email, password, admin_status = :user)
	admin = :admin == admin_status
	User.create({:email => email, :password => password, :admin => admin}, :without_protection => true)
end

def link_form_questions_to_form(form,questions)
	question_objects = []
	questions.each_with_index do |question_attributes,index|
		question_attributes[:form_type] = form.form_name
		question_attributes[:order] = index
		question_objects << FormQuestion.create(question_attributes)
	end
	form.form_questions << question_objects
end

objects_to_create = {}

create_a_user('admin@hostname.com', 'admin123', :admin)
create_a_user('user2@hostname.com', 'user1234')
create_a_user('user3@hostname.com', 'user1234')
create_a_user('user4@hostname.com', 'user1234')

# Application Types
vendor = ApplicationType.create({:app_type => 'Vendor Exhibitor'})
sponsor = ApplicationType.create({:app_type => 'Sponsor'})
non_profit = ApplicationType.create({:app_type => 'Non-Profit Exhibitor'})
other_vendor = ApplicationType.create({:app_type => 'All Other Vendors'})

# Questionnaire
#adding seeds questions, each question has an attribute referances its parent(like a tree), the tree is as follow:
#
#                   'Which one came first?'
#                     /                 \
#                  (egg)             (chicken)
#                   /                     \
#     'How do you like it?'          'Which part of chicken do you like?'
#      /        |        \              /         |          |        \
#(scramble)   (ssu)     (raw)      (breast)    (legs)     (wings)    (eggs)

objects_to_create[:Questionnaire] = [{:question => 'What type of Exhibitor are you?'}]

#answer table has answer to referance to its question, as well as which question it leads to
objects_to_create[:Answers] = [
	{:ans => vendor.app_type, :questionnaire_id => 1, :results_to => vendor.id},
	{:ans => sponsor.app_type, :questionnaire_id => 1, :results_to => sponsor.id},
	{:ans => non_profit.app_type, :questionnaire_id => 1, :results_to => non_profit.id},
	{:ans => other_vendor.app_type, :questionnaire_id => 1, :results_to => other_vendor.id}
]

# Forms
general_form = Form.create({:form_name => "General Form"})
restaurant_contract = Form.create({:form_name => "Restaurant Concessionaire Contract"})
sponsor_contract = Form.create({:form_name => "Sponsor Contract"})
non_profit_contract = Form.create({:form_name => "Exhibitor Contract - Non Profit"})
other_contract = Form.create({:form_name => "Exhibitor Contract - All other Exhibitors"})

vendor_solicitation = Form.create({:form_name => "Vendor Solicitation"})
sponsor_solicitation = Form.create({:form_name => "Sponsor Solicitation"})

advertising_contract = Form.create({:form_name => "Advertising Contract"})
health_permit_form = Form.create({:form_name => "Health Permit Form"})
conditions_of_agreement = Form.create({:form_name => "Conditions of Agreement"})
make_agreement = Form.create({:form_name => "Agreement"})


# Associate Application Types to forms
vendor.forms << [
	vendor_solicitation,
	general_form,
	restaurant_contract,
	conditions_of_agreement,
	advertising_contract,
	health_permit_form,
	vendor_solicitation,
	make_agreement
]

sponsor.forms << [
	sponsor_solicitation,
	general_form,
	restaurant_contract,
	conditions_of_agreement,
	advertising_contract,
	health_permit_form,
	sponsor_solicitation
	make_agreement
]

non_profit.forms << [
	vendor_solicitation,
	general_form,
	non_profit_contract,
	conditions_of_agreement,
	advertising_contract,
	sponsor_solicitation,
	make_agreement
]

other_vendor.forms << [
	vendor_solicitation,
	general_form,
	other_contract,
	conditions_of_agreement,
	advertising_contract,
	health_permit_form,
	sponsor_solicitation,
	make_agreement
]

# create form questions for each form
questions_for_form = {}

questions_for_form[general_form]  = [
	{:question => "Company Name", :question_type => :textbox},
	{:question => "Contact Person", :question_type => :textbox},
	{:question => "Mailing Address", :question_type => :textbox},
	{:question => "City", :question_type => :textbox},
	{:question => "State", :question_type => :textbox},
	{:question => "Zip", :question_type => :textbox},
	{:question => "Phone Number", :question_type => :textbox},
	{:question => "Alternate Number", :question_type => :textbox},
	{:question => "Fax", :question_type => :textbox},
	{:question => "Website", :question_type => :textbox},
	{:question => "Company name for WVF Program listing (if different from above)", :question_type => :textbox}
]

# Restuarant Concessionaire Contract
questions_for_form[restaurant_contract] = [
	{:question => 'Please provide a description of all items being displayed, promoted and/or sold. 
		Attach a seperate sheet if neccesary', 
		:question_type => :textbox},
	{:question => 'Food Guidelines...',
		:question_type => :statement},
	{:question => 'Will you be distributing food/beverage?', 
		:answers => "[Yes, No]",
	 	:question_type => :radio_button},
	{:question => 'Will you require a health permit?',
		:answers => "[Yes, No]", 
		:question_type => :radio_button},
	{:question => 'Will you use a stereo?', 
		:answers => "[Yes, No]", 
		:question_type => :radio_button},
	{:question => 'Exhibit Registration...', 
		:question_type => :statement},
	{:question => 'Food/Catering Booth Fee\n On or before July 15: $150\n After July 15:$250', 
		:answers => "[150, 250]", 
		:question_type => :radio_button},
	# {:question => 'Food Booth Fee',  
	# 	:question_type => :textbox},
	# {:question => 'City Health Permit Fee', 
	# 	:answers => "207", 
	# 	:question_type => :textbox},
	# {:question => 'Advertising:', 
	# 	:question_type => :textbox},
	# {:question => 'Total enclosed', 
	# 	:question_type => :textbox},
	# {:question => 'Please make payable to...', 
	# 	:question_type => :statement},
	{:question => 'Will you need electricity?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Please state electrical requirements...', 
		:question_type => :textbox},
	{:question => 'Name',
		:question_type => :textbox},
	{:question => 'Signature', 
		:question_type => :textbox},
	{:question => 'Title', 
		:question_type => :textbox},
	{:question => 'Date', 
		:question_type => :textbox}
] 

questions_for_form[advertising_contract] = 	[
	{:question => 'Full Page',
		:answers => "[Free, $500, N/A]",
		:question_type => :radio_button},
	{:question => 'Half Page',
		:answers => "[Free, $300, N/A]",
		:question_type => :radio_button},
	{:question => 'Quarter Page',
		:answers => "[Free, $200, N/A]",
		:question_type => :radio_button},
	{:question => 'One Eigth Page',
		:answers => "[$100, N/A]",
		:question_type => :radio_button},
	{:question => 'Business Card Size',
		:answers => "[$75, $50]",
		:question_type => :radio_button},
	{:question => 'Total Enclosed', 
		:question_type => :textbox},
	{:question => 'Encosed camera-ready ad/ logo...',
		:question_type => :checkbox},
	{:question => 'Email electronic copy...',
		:question_type => :checkbox},
	{:question => 'Mail Information',
		:question_type => :statement},
	{:question => 'Authorized Signature',
		:question_type => :textbox}
]

questions_for_form[conditions_of_agreement] = [
	{:question => 'Company/Organization', 
		:question_type => :textbox},
	{:question => 'Conditions of Agreement ......', 
		:answers => "[Agree]",
		:question_type => :radio_button}
]

questions_for_form[health_permit_form] = [
	{:question => "1. Name of Event:",
		:question_type => :textbox},
	{:question => "Location:",
		:question_type => :textbox},
	{:question => "Date(s):",
		:question_type => :textbox},
	{:question => "Number of booths:",
		:question_type => :textbox},
	{:question => "Number of Carts:",
		:question_type => :textbox},
	{:question => "Start Time:",
		:question_type => :textbox},
	{:question => "2. Company Name:",
		:question_type => :textbox},
	{:question => "Address:",
		:question_type => :textbox},
	{:question => "Phone:",
		:question_type => :textbox},
	{:question => "Fax:",
		:question_type => :textbox0},
	{:question => "Email:",
		:question_type => :textbox},
	{:question => "On-Site Representative:",
		:question_type => :textbox},
	{:question => "3. Name of Facility:",
		:question_type => :textbox},
	{:question => "Name & Address:",
		:question_type => :textbox},
	{:question => "Phone:",
		:question_type => :textbox},
	{:question => "Fax:",
		:question_type => :textbox},
	{:question => "E-mail:",
		:question_type => :textbox},
	{:question => "Travel Time:",
		:question_type => :textbox},
	{:question => "Plumbed Sink:",
		:question_type => :textbox},
	{:question => "Warm H20:",
		:question_type => :textbox},
	{:question => "3 compartment sink:",
		:question_type => :textbox},
	{:question => "Other method approved:",
		:question_type => :textbox},
	{:question => "Hot:",
		:question_type => :textbox},
	{:question => "Cold:",
		:question_type => :textbox},
	{:question => "Food Item:",
		:question_type => :textbox},
	{:question => "Off-Site Prep:",
		:question_type => :textbox},
	{:question => "Cooking Procedures:",
		:question_type => :textbox},
	{:question => "Holding Methods:",
		:question_type => :textbox},
	{:question => "Applicant Signaure:",
		:question_type => :textbox},
	{:question => "Date:",
		:question_type => :textbox},
	{:question => "Printed Name:",
		:question_type => :textbox}
]

questions_for_form[non_profit_contract] = 	[
	{:question => 'Product/Service Description',
		:question_type => :textbox},
	{:question => 'Non-Profit Registration',
		:question_type => :statement},
	{:question => 'Non-Profit Booth',
		:answers => "[$165, $215]",
		:question_type => :radio_button},
	{:question => 'Non-Profit Booth Fee',
		:question_type => :textbox},
	{:question => 'Electricity Fee, $75',
		:question_type => :textbox},
	{:question => 'Additional Chair $5 Each', 
		:question_type => :textbox},
	{:question => 'Advertising',
		:question_type => :textbox},
	{:question => 'TOTAL ENCLOSED',
		:question_type => :textbox},
	{:question => 'Please make check payable to...',
		:question_type => :statement},
	{:question => 'Will you need electricity?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Please state electrical requirements...',
		:question_type => :textbox}
]

questions_for_form[make_agreement] = [
	{:question => 'Agreement...',
		:question_type => :statement},
	{:question => "Name:",
		:question_type => :textbox},
	{:question => "Signature:",
		:question_type => :textbox},
	{:question => "Title:",
		:question_type => :textbox},
	{:question => "Date:",
		:question_type => :textbox}
]

questions_for_form[vendor_solicitation] = [
	{:question => 'BIG STATEMENT',
		:question_type => :statement}
]

questions_for_form[sponsor_solicitation] = [
	{:question => 'BIG STATEMENT',
		:question_type => :statement}
]

# sponsor_contract = Form.create({:form_name => "Sponsor Contract"})
# other_contract = Form.create({:form_name => "Exhibitor Contract - All other Exhibitors"})


questions_for_form.each do |form_object, form_question_attributes|
	link_form_questions_to_form form_object, form_question_attributes
end

# seed database for every object in objects_to_create
objects_to_create.each do|obj,params|
	obj_class = obj.to_s.constantize
	params.each do |a|
		obj_class.create!(a)
	end
end

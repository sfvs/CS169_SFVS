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

create_a_user('admin@hostname.com', 'admin123', :admin)
create_a_user('user2@hostname.com', 'user1234')
create_a_user('user3@hostname.com', 'user1234')
create_a_user('user4@hostname.com', 'user1234')

objects_to_create = {}

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
	{:ans => other_vendor, :questionnaire_id => 1, :results_to => other_vendor.id}
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


# Associate Application Types to forms
vendor.forms << [
	vendor_solicitation,
	general_form,
	restaurant_contract,
	conditions_of_agreement,
	advertising_contract,
	health_permit_form
]

sponsor.forms << [
	sponsor_solicitation,
	general_form,
	restaurant_contract,
	conditions_of_agreement,
	advertising_contract,
	health_permit_form
]

non_profit.forms << [
	vendor_solicitation,
	general_form,
	non_profit_contract,
	conditions_of_agreement,
	advertising_contract
]

other_vendor.forms << [
	vendor_solicitation,
	general_form,
	other_contract,
	conditions_of_agreement,
	advertising_contract,
	health_permit_form
]

# form_question attr :question, :app_type, :question_type, :order
general_form_questions = [
	{:question => "Name", :question_type => :textbox}
]


q1 = FormQuestion.create({:question => "Name", :form_type => "general", :question_type => :textbox, :order => 1})
q2 = FormQuestion.create({:question => "Company", :form_type => "general", :question_type => :textbox, :order => 2})


# Restuarant Concessionaire Contract
objects_to_create[:FormQuestion] = [
	{:question => 'Please provide a description of all items being displayed, promoted and/or 
	sold. Attach a seperate sheet if neccesary', 
	:form_type => :restaurant_concessionaire,
	:question_type => :textbox, 
	:order => 1},

	{:question => 'Food Guidelines...', 
		:form_type => :restaurant_concessionaire,
		:question_type => :statement, 
		:order => 2},

	{:question => 'Will you be distributing food/
	 beverage?', 
		:answers => "[Yes, No]", 
		:form_type => :restaurant_concessionaire,
	 	:question_type => :radio_button, 
		:order => 3},

	{:question => 'Will you require a health permit?', 
		:form_type => :restaurant_concessionaire,
		:question_type => :radio_button, 
		:order => 4},

	{:question => 'Will you use a stereo?', 
		:answers => "[Yes, No]", 
		:form_type => :restaurant_concessionaire,
		:question_type => :radio_button, 
		:order => 5},

	{:question => 'Exhibit Registration...', 
		:form_type => :restaurant_concessionaire,
		:question_type => :statement, 
		:order => 6},

	{:question => 'Food/Catering Booth Fee', 
		:answers => "[150, 250]", 
		:form_type => :restaurant_concessionaire,
		:question_type => :radio_button, 
		:order => 7},

	{:question => 'Food Booth Fee',  
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 8},

	#{:question => 'City Health Permit Fee', 
	#	"207", 
	#	:form_type => :restaurant_concessionaire,:textbox, 9},

	{:question => 'Advertising:', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 10},

	{:question => 'Total enclosed', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 11},

	{:question => 'Please make payable to...', 
		:form_type => :restaurant_concessionaire,
		:question_type => :statement, 
		:order => 21},

	{:question => 'Will you need electricity?', 
		:answers => "[Yes, No]", 
		:form_type => :restaurant_concessionaire,
		:question_type => :radio_button, 
		:order => 13},

	{:question => 'Please state electrical requirements...', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 14},

	{:question => 'Name', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 15},

	{:question => 'Signature', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 16},

	{:question => 'Title', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 17},

	{:question => 'Date', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 18},

	{:question => 'Company/Organization', 
		:form_type => :restaurant_concessionaire,
		:question_type => :textbox, 
		:order => 19}
] 

# seed database
objects_to_create.each do|obj,params|
	obj_class = obj.to_s.constantize
	params.each do |a|
		obj_class.create!(a)
	end
end
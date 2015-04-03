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
objects_to_create[:Answers] = [{:ans => :vendor, :questionnaire_id => 1},
		   {:ans => :donor, :questionnaire_id => 1},
		   {:ans => :restaurant_concessionaire, :questionnaire_id => 1},
		   {:ans => :other, :questionnaire_id => 1}]

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
													:order => 19}] 

objects_to_create[:FormQuestionnaire] = 	[{:form_question => 'Full Page', "[Free, $500, N/A]"
													:advertising_form,:radio_button, 1},
												{:form_question => 'Half Page', "[Free, $300, N/A]"
													:advertising_form,:radio_button, 2},
												{:form_question => 'Quarter Page', "[Free, $200, N/A]"
													:advertising_form,:radio_button, 3},
												{:form_question => 'One Eigth Page', "[$100, N/A]"
													:advertising_form,:radio_button, 4},
												{:form_question => 'Business Card Size', "[$75, $50]"
													:advertising_form,:radio_button, 5},
												{:form_question => 'Total Enclosed', 
													:advertising_form,:textbox, 6},
												{:form_question => 'Encosed camera-ready ad/ logo...',
													:advertising_form,:checkbox, 7},
												{:form_question => 'Email electronic copy...',
													:advertising_form,:checkbox, 8},
												{:form_question => 'Mail Information',
													:advertising_form,:statement, 9},
												{:form_question => 'Authorized Signature',
													:advertising_form,:textbox, 10}]

objects_to_create[:FormQuestionnaire] = 	[{:question => "1. Name of Event:", :app_type => :health_form,
													:question_type => :textbox, :order => 1},
											 {:question => "Location:", :app_type => :health_form,
													:question_type => :textbox, :order => 2},
											 {:question => "Date(s):", :app_type => :health_form,
													:question_type => :textbox, :order => 3},
											 {:question => "Number of booths:", :app_type => :health_form,
													:question_type => :textbox, :order => 4},
											 {:question => "Number of Carts:", :app_type => :health_form,
													:question_type => :textbox, :order => 5},
											 {:question => "Start Time:", :app_type => :health_form,
													:question_type => :textbox, :order => 6},
											 {:question => "2. Company Name:", :app_type => :health_form,
													:question_type => :textbox, :order => 7},
											 {:question => "Address:", :app_type => :health_form,
													:question_type => :textbox, :order => 8},
											 {:question => "Phone:", :app_type => :health_form,
													:question_type => :textbox, :order => 9},
											 {:question => "Fax:", :app_type => :health_form,
													:question_type => :textbox, :order => 10},
											 {:question => "Email:", :app_type => :health_form,
													:question_type => :textbox, :order => 11},
											 {:question => "On-Site Representative:", :app_type => :health_form,
													:question_type => :textbox, :order => 12},
											 {:question => "3. Name of Facility:", :app_type => :health_form,
													:question_type => :textbox, :order => 13},
											 {:question => "Name & Address:", :app_type => :health_form,
													:question_type => :textbox, :order => 14},
											 {:question => "Phone:", :app_type => :health_form,
													:question_type => :textbox, :order => 15},
											 {:question => "Fax:", :app_type => :health_form,
													:question_type => :textbox, :order => 16},
											 {:question => "E-mail:", :app_type => :health_form,
													:question_type => :textbox, :order => 17},
											 {:question => "Travel Time:", :app_type => :health_form,
													:question_type => :textbox, :order => 18},
											 {:question => "Plumbed Sink:", :app_type => :health_form,
													:question_type => :textbox, :order => 19},
											 {:question => "Warm H20:", :app_type => :health_form,
													:question_type => :textbox, :order => 20},
											 {:question => "3 compartment sink:", :app_type => :health_form,
													:question_type => :textbox, :order => 21},
											 {:question => "Other method approved:", :app_type => :health_form,
													:question_type => :textbox, :order => 21},
											 {:question => "Hot:", :app_type => :health_form,
													:question_type => :textbox, :order => 23},
											 {:question => "Cold:", :app_type => :health_form,
													:question_type => :textbox, :order => 24},
											 {:question => "Food Item:", :app_type => :health_form,
													:question_type => :textbox, :order => 25},
											 {:question => "Off-Site Prep:", :app_type => :health_form,
													:question_type => :textbox, :order => 26},
											 {:question => "Cooking Procedures:", :app_type => :health_form,
													:question_type => :textbox, :order => 27},
											 {:question => "Holding Methods:", :app_type => :health_form,
													:question_type => :textbox, :order => 28}
											 {:question => "Applicant Signature:", :app_type => :health_form,
													:question_type => :textbox, :order => 29},
											 {:question => "Date:", :app_type => :health_form,
													:question_type => :textbox, :order => 30},
											 {:question => "Printed Name:", :app_type => :health_form,
													:question_type => :textbox, :order => 31]	
# seed database
objects_to_create.each do|obj,params|
	obj_class = obj.to_s.constantize
	params.each do |a|
		obj_class.create!(a)
	end
end

gen_form = Form.create({:form_name => "General Form"}, :without_protection => true)

# form_question attr :question, :app_type, :question_type, :order
q1 = FormQuestion.create({:question => "Name", :form_type => "general", :question_type => :textbox, :order => 1})
q2 = FormQuestion.create({:question => "Company", :form_type => "general", :question_type => :textbox, :order => 2})
gen_form.form_questions << q1
gen_form.form_questions << q2

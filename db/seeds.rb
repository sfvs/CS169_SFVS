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

# objects_to_create[:FormQuestions] = [{:form_question => 'Please provide a description 
# 												of all items being displayed, promoted and/or 
# 												sold. Attach a seperate sheet if neccesary', :restaurant_concessionaire,
# 												:textbox, 1},
# 												{:form_question => 'Food Guidelines...', :restaurant_concessionaire,
# 													:statement, 2},
# 												{:form_question => 'Will you be distributing food/
# 												 beverage?', "[Yes, No]", :restaurant_concessionaire,
# 												 :radio_button, 3},
# 												{:form_question => 'Will you require a health permit?', 
# 												"[Yes, No]", :restaurant_concessionaire,:radio_button, 4},
# 												{:form_question => 'Will you use a stereo?', "[Yes, No]", 
# 													:restaurant_concessionaire,:radio_button, 5},
# 												{:form_question => 'Exhibit Registration...', :restaurant_concessionaire,
# 													:statement, 6},
# 												{:form_question => 'Food/Catering Booth Fee', "[150, 250]", 
# 													:restaurant_concessionaire,:radio_button, 7},
# 												{:form_question => 'Food Booth Fee',  
# 													:restaurant_concessionaire,:textbox, 8},
# 												{:form_question => 'City Health Permit Fee', "207", 
# 													:restaurant_concessionaire,:textbox, 9},
# 												{:form_question => 'Advertising:', 
# 													:restaurant_concessionaire,:textbox, 10},
# 												{:form_question => 'Total enclosed', 
# 													:restaurant_concessionaire,:textbox, 11},
# 												{:form_question => 'Please make payable to...', :restaurant_concessionaire,
# 													:statement, 21},
# 												{:form_question => 'Will you need electricity?', "[Yes, No]", 
# 													:restaurant_concessionaire,:radio_button, 13},
# 												{:form_question => 'Please state electrical requirements...', 
# 													:restaurant_concessionaire,:textbox, 14},
# 												{:form_question => 'Name', 
# 													:restaurant_concessionaire,:textbox, 15},
# 												{:form_question => 'Signature', 
# 													:restaurant_concessionaire,:textbox, 16},
# 												{:form_question => 'Title', 
# 													:restaurant_concessionaire,:textbox, 17},
# 												{:form_question => 'Date', 
# 													:restaurant_concessionaire,:textbox, 18}
# 												{:form_question => 'Company/Organization', 
# 													:restaurant_concessionaire,:textbox, 19}] 

# seed database
objects_to_create.each do|obj,params|
	obj_class = obj.to_s.constantize
	params.each do |a|
		obj_class.create!(a)
	end
end

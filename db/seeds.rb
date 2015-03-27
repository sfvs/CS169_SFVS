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

#adding seeds questions, each question has an attribute referances its parent(like a tree), the tree is as follow:
#
#                   'Which one came first?'
#                     /                 \
#                  (egg)             (chicken)
#                   /                     \
#     'How do you like it?'          'Which part of chicken do you like?'
#      /        |        \              /         |          |        \
#(scramble)   (ssu)     (raw)      (breast)    (legs)     (wings)    (eggs)


questions = [{:question => 'What type of Exhibitor are you?'}]

#answer table has answer to referance to its question, as well as which question it leads to
answers = [{:ans => :Vendor, :questionnaire_id => 1},
		   {:ans => :Donor, :questionnaire_id => 1},
		   {:ans => :Restaurant_Concessionaire, :questionnaire_id => 1},
		   {:ans => :Other, :questionnaire_id => 1}]

questions.each do |q|
	Questionnaire.create!(q)
end

answers.each do |a|
	Answers.create!(a)
end

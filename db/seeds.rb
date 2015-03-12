# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create({email: 'admin@hostname.com', password: 'admin123', admin: true}, :without_protection => true)
User.create({email: 'user2@hostname.com', password: 'user1234', admin: false}, :without_protection => true)


#adding seeds questions, each question has an attribute referances its parent(like a tree), the tree is as follow:
#
#                   'Which one came first?'
#                     /                 \
#                  (egg)             (chicken)
#                   /                     \
#     'How do you like it?'          'Which part of chicken do you like?'
#      /        |        \              /         |          |        \
#(scramble)   (ssu)     (raw)      (breast)    (legs)     (wings)    (eggs)


questions = [{:question => 'Which one came first?'},
			 {:question => 'How do you like it?', :parent_id => 1},
			 {:question => 'which part of chicken do you like?', :parent_id => 1}]

#answer table has answer to referance to its question, as well as which question it leads to
answers = [{:ans => 'egg', :questionnaire_id => 1, :leads_to => 2},
		   {:ans => 'chicken', :questionnaire_id => 1, :leads_to => 3},
		   {:ans => 'scramble', :questionnaire_id => 2},
		   {:ans => 'sunny side up', :questionnaire_id => 2},
		   {:ans => 'raw', :questionnaire_id => 2},
		   {:ans => 'breast', :questionnaire_id => 3},
		   {:ans => 'legs', :questionnaire_id => 3},
		   {:ans => 'wings', :questionnaire_id => 3},
		   {:ans => 'eggs', :questionnaire_id => 3}]


questions.each do |q|
	Questionnaire.create!(q)
end

answers.each do |a|
	Answers.create!(a)
end
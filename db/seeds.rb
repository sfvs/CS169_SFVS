# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_a_user(email, password, contact_person = "", company_name  = "", phone_number  = "", admin_status = :user)
	admin = :admin == admin_status
	User.create({:email => email, :password => password, :admin => admin, :contact_person => contact_person, :company_name => company_name, :telephone => phone_number}, :without_protection => true)
end

def link_form_questions_to_form(form,questions)
	question_objects = []
	questions.each_with_index do |question_attributes,index|
		question_attributes[:form_type] = form.form_name
		question_attributes[:order] = index + 1
		question_objects << FormQuestion.create(question_attributes)
	end
	form.form_questions << question_objects
end

objects_to_create = {}

create_a_user('admin@hostname.com', 'admin123', "", "", "", :admin)
create_a_user('user2@hostname.com', 'user1234', "John Wick", "Pineapple", "512-123-1235")
create_a_user('user3@hostname.com', 'user1234', "Kevin Chavez", "Apple", "232-567-4234")
create_a_user('user4@hostname.com', 'user1234', "Paul Lee", "Orange", "185-323-3523")

# Application Types
vendor_non_food = ApplicationType.create({:app_type => 'Vendor Exhibitor for Non-Food Items or Services'})
sponsor = ApplicationType.create({:app_type => 'Sponsor'})
non_profit = ApplicationType.create({:app_type => 'Non-Profit Exhibitor'})
vendor_food = ApplicationType.create({:app_type => 'Vendor Exhibitor of Food Items'})
restaurant_concessionaire = ApplicationType.create({:app_type => 'Restaurant Food Concessionaire'})

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

objects_to_create[:Questionnaire] = [
	{:question => 'What type of Exhibitor are you?'}
]

#answer table has answer to referance to its question, as well as which question it leads to

objects_to_create[:Answers] = [
	{:ans => vendor_non_food.app_type, :questionnaire_id => 1, :results_to => vendor_non_food.id},
	{:ans => sponsor.app_type, :questionnaire_id => 1, :results_to => sponsor.id},
	{:ans => non_profit.app_type, :questionnaire_id => 1, :results_to => non_profit.id},
	{:ans => vendor_food.app_type, :questionnaire_id => 1, :results_to => vendor_food.id},
	{:ans => restaurant_concessionaire.app_type, :questionnaire_id => 1, :results_to => restaurant_concessionaire.id}
]

# Forms
company_information = Form.create({:form_name => "Company Information"})

non_food_contract = Form.create({:form_name => "Exhibitor Vendor - Non Food Items and Services"})
restaurant_contract = Form.create({:form_name => "Restaurant Concessionaire Contract"})
sponsor_contract = Form.create({:form_name => "Sponsor Contract"})
non_profit_contract = Form.create({:form_name => "Exhibitor Contract - Non Profit"})
food_item_contract = Form.create({:form_name => "Exhibitor Contract of Food Items"})

advertising_non_sponsor_contract = Form.create({:form_name => "Advertising Contract"})
advertising_sponsor_contract = Form.create({:form_name => "Advertising Contract"})


health_permit_form = Form.create({:form_name => "Health Permit Form"})
restaurant_health_permit_form = Form.create({:form_name => "Health Permit Form"})

conditions_of_agreement = Form.create({:form_name => "Conditions of Agreement"})
make_agreement = Form.create({:form_name => "Agreement"})

setup_instructions = Form.create({:form_name => "Setup Instructions"})


# Associate Application Types to forms
vendor_non_food.forms << [
	company_information,
	non_food_contract,
	advertising_non_sponsor_contract,
	conditions_of_agreement,
	make_agreement,
	setup_instructions
]

vendor_food.forms << [
	company_information,
	food_item_contract,
	advertising_non_sponsor_contract,
	health_permit_form,
	conditions_of_agreement,
	make_agreement,
	setup_instructions
]

sponsor.forms << [
	company_information,
	sponsor_contract,
	advertising_sponsor_contract,
	conditions_of_agreement,
	make_agreement,
	setup_instructions
]

non_profit.forms << [
	company_information,
	non_profit_contract,
	advertising_non_sponsor_contract,
	conditions_of_agreement,
	make_agreement,
	setup_instructions
]

restaurant_concessionaire.forms << [
	company_information,
	restaurant_contract,
	advertising_non_sponsor_contract,
	restaurant_health_permit_form,
	conditions_of_agreement,
	make_agreement,
	setup_instructions
]

# create form questions for each form
questions_for_form = {}

# General Information Forms

questions_for_form[company_information]  = [
	{:question => "Mailing Address", :question_type => :textbox},
	{:question => "City", :question_type => :textbox},
	{:question => "State", :question_type => :textbox},
	{:question => "Zip", :question_type => :textbox},
	{:question => "Fax", :question_type => :textbox},
	{:question => "Website", :question_type => :textbox},
	{:question => "Company name for WVF Program listing", :question_type => :textbox}
]

# Main Contract Forms

# questions_for_form[non_food_contract] = [
# 	{:question => 'Please provide a description of all items being displayed, promoted and/or sold. 
# 		Attach a seperate sheet if neccesary', 
# 		:question_type => :message},
# 	{:question => 'Food Guidelines...',
# 		:question_type => :statement},
# 	# {:question => 'Will you require a health permit?',
# 	# 	:answers => "[Yes, No]", 
# 	# 	:question_type => :radio_button},
# 	{:question => 'Will you use a sterno?', 
# 		:answers => "[Yes, No]", 
# 		:question_type => :radio_button},
# 	{:question => 'Exhibit Registration...', 
# 		:question_type => :statement},
# 	# {:question => 'Food Booth Fee',  
# 	# 	:question_type => :textbox},
# 	# {:question => 'City Health Permit Fee', 
# 	# 	:answers => "207", 
# 	# 	:question_type => :textbox},
# 	# {:question => 'Advertising:', 
# 	# 	:question_type => :textbox},
# 	# {:question => 'Total enclosed', 
# 	# 	:question_type => :textbox},
# 	# {:question => 'Please make payable to...', 
# 	# 	:question_type => :statement},
# 	{:question => 'Will you need electricity?',
# 		:answers => "[Yes, No]",
# 		:question_type => :radio_button},
# 	{:question => 'Please state electrical requirements...', 
# 		:question_type => :textbox}
# ]

questions_for_form[restaurant_contract] = [
	{:question => 'Product/Services Description',
		:question_type => :statement},
	{:question => 'Please provide a description of all items being displayed, promoted and/or sold, or N/A for none.',
		:question_type => :message},
	{:question => 'Food Guidelines (only Vegan foods are allowed)
		All food items must fall under the following categories to be promoted at the World Vegetarian Festival.
		
		- Unpackaged vegan food or beverage samples may be sold or given away for free by Exhibitor in accordance 
		with SF Health Department guidelines. Requires high risk city health permit of $207.

		- Pre packaged vegan food items may be sold or given away by Exhibitors. 
		Requires low risk city health permit of $105.

		Use of recyclable, compostable or biodegradable supplies are highly encouraged in order to conserve the environment.

		Non Food Guidelines
		We only allow vegan items that have not have been tested on animals, and are free of leather, 
		fur, gelatin, silk, wool or any other animal derivatives.',
		:question_type => :statement},
	{:question => 'Will you be distributing food/beverage samples?',
		:answers => "[Yes]",
		:question_type => :radio_button},
	{:question => 'Will you use a sterno?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Do you guarantee your products on display at the Festival to be vegan?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => "Exhibit Registration
		Registration fee is payable in advance and applicable for 2 days. Space is limited.
		Fee includes one booth space, one table and one chair.",
		:question_type => :statement},
	{:question => 'Food/Catering Booth',
		:answers => '[$150 (Payment on or before Aug 15th), $250 (Payment after Aug 15th)]',
		:question_type => :radio_button},
	{:question => 'Will you need electricity?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'If yes, please state electrical requirements (including watts and/or amps) and type of equipment you will be bringing.
		List Equipment & Watts (not to exceed 1920 watts or 16 amps). If no, write N/A',
		:question_type => :message}
]

questions_for_form[sponsor_contract] = [
	{:question => 'Product/Services Description',
		:question_type => :statement},
	{:question => 'Please provide a description of all items being displayed, promoted and/or sold, or N/A for none.',
		:question_type => :message},
	{:question => 'Food Guidelines (only Vegan foods are allowed)
		All food items must fall under the following categories to be promoted at the World Vegetarian Festival.
		
		- Unpackaged vegan food or beverage samples may be sold or given away for free by Exhibitor in accordance 
		with SF Health Department guidelines. Requires high risk city health permit of $207.

		- Pre packaged vegan food items may be sold or given away by Exhibitors. 
		Requires low risk city health permit of $105.

		Use of recyclable, compostable or biodegradable supplies are highly encouraged in order to conserve the environment.

		Non Food Guidelines
		We only allow vegan items that have not have been tested on animals, and are free of leather, 
		fur, gelatin, silk, wool or any other animal derivatives.',
		:question_type => :statement},
	{:question => 'Will you be distributing food/beverage samples?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Will you use a sterno?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Do you guarantee your products on display at the Festival to be vegan?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => "Sponsor Information
		Principal Sponsor ($3,000)
		- Booth (12' x 8')
		- Prominent Exhibit Location
		- Two tables with two chairs
		- Name on all publicity
		- Full page ad in event program
		- Logo Link on SFVS website
		- Product Exclusivity

		Major Sponsor ($2,000)
		- Booth (12' x 8')
		- Two tables with two chairs
		- Name on special publicity
		- Half page ad in event program
		- Logo Link on SFVS website
 
		Associate Sponsor ($1,000)
		- Booth (8' x 8')
		- One tables with two chairs
		- Newsletter recognition
		- Quarter page ad in program

		Supporting Sponsor (non exhibiting) ($500)
		- Newsletter recognition
		- Quarter page ad in program

		Included above are 6' x 2.5' table/s, chairs, health permits, and electricity (except non-exhibitor).",
		:question_type => :statement},
	{:question => 'Please select your Sponsorship type:',
		:answers => "[Principal Sponsor, Major Sponsor, Associate Sponsor, Supporting Sponsor (non exhibiting)]",
		:question_type => :radio_button},
	{:question => 'Will you need electricity?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'If yes, please state electrical requirements (including watts and/or amps) and type of equipment you will be bringing.
		List Equipment & Watts (below 1000 watts or 12 amps). If no, write N/A',
		:question_type => :message}
]

questions_for_form[food_item_contract] = [
	{:question => 'Product/Services Description',
		:question_type => :statement},
	{:question => 'Please provide a description of all items being displayed, promoted and/or sold, or N/A for none.',
		:question_type => :message},
	{:question => 'Food Guidelines (only Vegan foods are allowed)
		All food items must fall under the following categories to be promoted at the World Vegetarian Festival.
		
		- Unpackaged vegan food or beverage samples may be sold or given away for free by Exhibitor in accordance 
		with SF Health Department guidelines. Requires high risk city health permit of $207.

		- Pre packaged vegan food items may be sold or given away by Exhibitors. 
		Requires low risk city health permit of $105.

		Use of recyclable, compostable or biodegradable supplies are highly encouraged in order to conserve the environment.

		Non Food Guidelines
		We only allow vegan items that have not have been tested on animals, and are free of leather, 
		fur, gelatin, silk, wool or any other animal derivatives.',
		:question_type => :statement},
	{:question => 'Will you be distributing food/beverage samples?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Will you use a sterno?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Do you guarantee your products on display at the Festival to be vegan?',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => "Exhibit Registration
		Registration fee is payable in advance and applicable for 2 days. Space is limited.
		Fee includes health permit fees and processing, one booth space,
		one chair and one table (6' x 2.5').",
		:question_type => :statement},
	{:question => 'Exhibit Booth',
		:answers => '[Regular Booth "B" - Open Courtyard: $150 (Payment on or before Aug 15th),
		Regular Booth "B" - Open Courtyard: $250 (Payment after Aug 15th),
		Regular Booth "C" - Gallery Bldg: $200 (Payment on or before Aug 15th),
		Regular Booth "C" - Gallery Bldg: $300 (Payment after Aug 15th)]',
		:question_type => :radio_button},
	{:question => 'Additional Chair $5 Each', 
		:answers => "[0, 1, 2, 3, 4, 5]",
		:question_type => :radio_button},
	{:question => 'Will you need electricity? ($75 fee)',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'If yes, please state electrical requirements (including watts and/or amps) and type of equipment you will be bringing.
		List Equipment & Watts (not to exceed 1920 watts or 16 amps). If no, write N/A',
		:question_type => :message}
]

questions_for_form[non_profit_contract] = 	[
	{:question => 'Product/Services Description',
		:question_type => :statement},
	{:question => 'Please provide a description of all items being displayed, promoted and/or sold, or N/A for none.',
		:question_type => :message},
	{:question => 'Non-Profit Registration
		Registration fee is payable in advance and applicable for 2 days.
		Space is limited. The fee includes one booth space (approx 8 x 6 ft), one table and one chair.
		Booth is inside the building. NO REFUNDS AFTER AUGUST 15.',
		:question_type => :statement},
	{:question => 'Non-Profit Booth',
		:answers => "[Payment on or before Aug 15th: $165, Payment after Aug 15th: $215]",
		:question_type => :radio_button},
	{:question => 'Additional Chair $5 Each', 
		:answers => "[0, 1, 2, 3, 4, 5]",
		:question_type => :radio_button},
	{:question => 'Will you need electricity? ($75 fee)',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'If yes, please state electrical requirements (including watts and/or amps) and type of equipment you will be bringing.
		List Equipment & Watts (not to exceed 1920 watts or 16 amps). If no, write N/A',
		:question_type => :message}
]

# Advertising Forms

questions_for_form[advertising_sponsor_contract] = 	[
	{:question => 'Ads - Program Book Size  8 1/2" x 11" (2,000 copies)
		All ads are one color (black print)',
		:question_type => :statement},
	{:question => 'Please select a size of your advertisement:',
		:answers => '[Full Page (8.5"w x 11"h), Half Page (8.5"w x 5.5"h), Quarter Page (4.25"w x 5.5"h)]',
		:question_type => :checkbox},
	{:question => 'Additional Information
		Deadline: July 1
		Minimum Specs: Tiff or PDF file; 1600 x 1200 pixels; 300 dpi

		Enclosed camera-ready ad/logo and mail to address below, or
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement},
	# {:question => 'Please upload here',
	# 	:question_type => :textbox},
	{:question => 'Authorized Signature',
		:question_type => :textbox}
]

questions_for_form[advertising_non_sponsor_contract] = 	[
	{:question => 'Ads - Program Book Size  8 1/2" x 11" (2,000 copies)
		All ads are one color (black print)',
		:question_type => :statement},
	{:question => 'Half Page (8.5"w x 5.5"h): $300',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Quarter Page (4.25"w x 5.5"h): $200',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'One Eigth Page (4.25"w x 2.75"h): $100',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Business Card Size (3.5"w x 2"h): $50',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Additional Information
		Deadline: August 31
		Minimum Specs: Tiff or PDF file; 1600 x 1200 pixels; 300 dpi

		Enclosed camera-ready ad/logo and mail to address below, or
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement},
	# {:question => 'Please upload here',
	# 	:question_type => :textbox},
	{:question => 'Authorized Signature',
		:question_type => :textbox}
]

# questions_for_form[conditions_of_agreement] = [
# 	{:question => 'Company/Organization', 
# 		:question_type => :textbox},
# 	{:question => 'Conditions of Agreement ......', 
# 		:answers => "[Agree]",
# 		:question_type => :radio_button}
# ]

# questions_for_form[make_agreement] = [
# 	{:question => 'Agreement...',
# 		:question_type => :statement},
# 	{:question => "Name:",
# 		:question_type => :textbox},
# 	{:question => "Signature:",
# 		:question_type => :textbox},
# 	{:question => "Title:",
# 		:question_type => :textbox},
# 	{:question => "Date:",
# 		:question_type => :textbox}
# ]

questions_for_form[health_permit_form] = [
	{:question => 'Food Guidelines (only Vegan foods are allowed)
		All food items must fall under the following categories to be promoted at the World Vegetarian Festival.
		
		- Unpackaged vegan food or beverage samples may be sold or given away for free by Exhibitor in accordance 
		with SF Health Department guidelines. Requires high risk city health permit of $207.

		- Pre packaged vegan food items may be sold or given away by Exhibitors. 
		Requires low risk city health permit of $105.

		Use of recyclable, compostable or biodegradable supplies are highly encouraged in order to conserve the environment.

		Non Food Guidelines
		We only allow vegan items that have not have been tested on animals, and are free of leather, 
		fur, gelatin, silk, wool or any other animal derivatives.',
		:question_type => :statement},
	{:question => 'Do you require a health permit (answer "yes" if you will be selling or giving away foods or food samples)?
		Health permits are required and will be processed by SFVS.',
		:answers => "[Yes, No]",
		:question_type => :radio_button},
	{:question => 'Health permit Fee',
		:answers => "[High risk city health permit: $207, Low risk city health permit: $105]",
		:question_type => :radio_button},
	{:question => 'Additional Information
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement}

	# {:question => "1. Name of Event:",
	# 	:question_type => :textbox},
	# {:question => "Location:",
	# 	:question_type => :textbox},
	# {:question => "Date(s):",
	# 	:question_type => :textbox},
	# {:question => "Number of booths:",
	# 	:question_type => :textbox},
	# {:question => "Number of Carts:",
	# 	:question_type => :textbox},
	# {:question => "Start Time:",
	# 	:question_type => :textbox},
	# {:question => "2. Company Name:",
	# 	:question_type => :textbox},
	# {:question => "Address:",
	# 	:question_type => :textbox},
	# {:question => "Phone:",
	# 	:question_type => :textbox},
	# {:question => "Fax:",
	# 	:question_type => :textbox0},
	# {:question => "Email:",
	# 	:question_type => :textbox},
	# {:question => "On-Site Representative:",
	# 	:question_type => :textbox},
	# {:question => "3. Name of Facility:",
	# 	:question_type => :textbox},
	# {:question => "Name & Address:",
	# 	:question_type => :textbox},
	# {:question => "Phone:",
	# 	:question_type => :textbox},
	# {:question => "Fax:",
	# 	:question_type => :textbox},
	# {:question => "E-mail:",
	# 	:question_type => :textbox},
	# {:question => "Travel Time:",
	# 	:question_type => :textbox},
	# {:question => "Plumbed Sink:",
	# 	:question_type => :textbox},
	# {:question => "Warm H20:",
	# 	:question_type => :textbox},
	# {:question => "3 compartment sink:",
	# 	:question_type => :textbox},
	# {:question => "Other method approved:",
	# 	:question_type => :textbox},
	# {:question => "Hot:",
	# 	:question_type => :textbox},
	# {:question => "Cold:",
	# 	:question_type => :textbox},
	# {:question => "Food Item:",
	# 	:question_type => :textbox},
	# {:question => "Off-Site Prep:",
	# 	:question_type => :textbox},
	# {:question => "Cooking Procedures:",
	# 	:question_type => :textbox},
	# {:question => "Holding Methods:",
	# 	:question_type => :textbox},
	# {:question => "Applicant Signaure:",
	# 	:question_type => :textbox},
	# {:question => "Date:",
	# 	:question_type => :textbox},
	# {:question => "Printed Name:",
	# 	:question_type => :textbox}
]

questions_for_form[restaurant_health_permit_form] = [
	{:question => 'Food Guidelines (only Vegan foods are allowed)
		All food items must fall under the following categories to be promoted at the World Vegetarian Festival.
		
		- Unpackaged vegan food or beverage samples may be sold or given away for free by Exhibitor in accordance 
		with SF Health Department guidelines. Requires high risk city health permit of $207.

		- Pre packaged vegan food items may be sold or given away by Exhibitors. 
		Requires low risk city health permit of $105.

		Use of recyclable, compostable or biodegradable supplies are highly encouraged in order to conserve the environment.

		Non Food Guidelines
		We only allow vegan items that have not have been tested on animals, and are free of leather, 
		fur, gelatin, silk, wool or any other animal derivatives.',
		:question_type => :statement},
	{:question => 'Health permit Fee',
		:answers => "[High risk city health permit: $207]",
		:question_type => :radio_button},
	{:question => 'Additional Information
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement}
]

questions_for_form[setup_instructions] = [
	{:question => 'For your convenience, we have arranged a Friday set-up time from 2:00 - 4:00 p.m.',
		:question_type => :statement},
	{:question => 'On the day of the event, check-in and set-up time: 8:00 - 9:30 a.m. 
		Please complete set up by 9:30 a.m. After 9:30 a.m., SFVS reserves the right 
		to assign an empty booth without any further obligation.',
		:question_type => :statement},
	{:question => 'The building facilities will be locked the evenings of Friday and Saturday. 
		You may leave non-valuables items inside the Gallery. There are no security guards in the evening.',
		:question_type => :statement},
	{:question => "Exhibitors' gallery must be vacated Sunday by 7:00 p.m.",
		:question_type => :statement},
	{:question => 'Area(s) rented must be swept and, if necessary, mopped at the end of each day. 
		Please bring your own brooms, mops and dust pans. A $50 cleaning fee may be assessed to booths 
		not left clean as determined by SFVS.',
		:question_type => :statement},
	{:question => 'SFVS has GARBAGE, RECYCLING and COMPOST dumpsters adequately marked behind the 
		building. Do not use the County Fair Building dumpster. Garbage must be taken with 
		ou on departure or placed in the marked SFVS dumpster located at the back of the Gallery building. 
		Cardboard boxes must be broken apart for recycling.',
		:question_type => :statement},
	{:question => "Screws, tacks or tape must not be used to fasten items to walls, 
		cabinets,windowsills, doorways or ceiling. Scotch brand, blue painter's tape may be used.",
		:question_type => :statement},
	{:question => 'If you need to hang a heavy banner, you may need to supply your own banner 
		stands and you are advised to do your set-up on a Friday.',
		:question_type => :statement},
	{:question => "Flyers, advertising or information materials can only be posted in the exhibitor's exhibit space.",
		:question_type => :statement},
	{:question => 'Loading and unloading is located at the Lincoln Way entrance. 
		No permanent parking allowed. These are reserved spaces and your vehicle 
		may be towed by the County Fair building management.',
		:question_type => :statement},
	{:question => 'Parking inside the park is limited to 4 hours. 
		You may park on Lincoln Way or at the UCSF garage (See directions page). 
		There is also a whole day public garage parking located in the Park by the Japanese Tea Garden.',
		:question_type => :statement},
	{:question => 'No propane gas tank is allowed for heating or cooking inside the building.',
		:question_type => :statement},
	{:question => 'No animals or pets are allowed inside the premises with the exception of 
		guide or service dogs or animals needed by the disabled.',
		:question_type => :statement},
	{:question => 'Emergency and first aid services will be provided at the SFVS Volunteer Booth 
		located at the middle of the Gallery.',
		:question_type => :statement}
]

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

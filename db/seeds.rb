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
		question_str = question_attributes[:question]
		question_attributes[:question] = question_str.gsub(/\t/, '')
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
vendor_non_food = ApplicationType.create({:app_type => 'Vendor Exhibitor for Non-Food Items or Services', 
										  :description => 'Vendors who DO NOT sell or giveaway any food items.
										  - All other types of businesses can use this form.
										  - Non-profit organizations need to use another form.'})
sponsor = ApplicationType.create({:app_type => 'Sponsor',
								  :description => 'Any exhibitor or vendor who is willing to co-sponsor the event 
								  					for a productexclusivity and also be included in the festival 
								  					advertising and promotional campaign at no additional cost.'})
non_profit = ApplicationType.create({:app_type => 'Non-Profit Exhibitor',
									 :description => 'Any IRS registered tax exempt organization.'})
vendor_food = ApplicationType.create({:app_type => 'Vendor Exhibitor of Food Items',
									  :description => 'Vendors who Do sell or giveaway any food items.  
									  					- All types of businesses can use this form.
									  					- Non-profit organizations need to use another form.'})
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
	{:question => 'Choose your application type. (Click on application to view detail)'},
	{:question => vendor_non_food.description, :parent_id => 1},
	{:question => sponsor.description, :parent_id => 1},
	{:question => non_profit.description, :parent_id => 1},
	{:question => vendor_food.description, :parent_id => 1}
]

#answer table has answer to referance to its question, as well as which question it leads to

objects_to_create[:Answers] = [
	{:ans => vendor_non_food.app_type, :questionnaire_id => 1, :leads_to => 2},
	{:ans => sponsor.app_type, :questionnaire_id => 1, :leads_to => 3},
	{:ans => non_profit.app_type, :questionnaire_id => 1, :leads_to => 4},
	{:ans => vendor_food.app_type, :questionnaire_id => 1, :leads_to => 5},
	{:ans => restaurant_concessionaire.app_type, :questionnaire_id => 1, :results_to => restaurant_concessionaire.id},
	{:ans => 'I am a ' + vendor_non_food.app_type, :questionnaire_id => 2, :results_to => vendor_non_food.id},
	{:ans => 'I am a ' + sponsor.app_type, :questionnaire_id => 3, :results_to => sponsor.id},
	{:ans => 'I am a ' + non_profit.app_type, :questionnaire_id => 4, :results_to => non_profit.id},
	{:ans => 'I am a ' + vendor_food.app_type, :questionnaire_id => 5, :results_to => vendor_food.id}
	# {:ans => vendor_non_food.app_type, :questionnaire_id => 1, :results_to => restaurant_concessionaire.id},
	# {:ans => sponsor.app_type, :questionnaire_id => 1, :results_to => vendor_non_food.id},
	# {:ans => non_profit.app_type, :questionnaire_id => 1, :results_to => sponsor.id},
	# {:ans => vendor_food.app_type, :questionnaire_id => 1, :results_to => non_profit.id}
]

# Forms
company_information = Form.create({:form_name => "Company Information"})

non_food_contract = Form.create({:form_name => "Exhibitor Vendor - Non Food Items and Services"})
restaurant_contract = Form.create({:form_name => "Restaurant Concessionaire Contract"})
sponsor_contract = Form.create({:form_name => "Sponsor Contract"})
non_profit_contract = Form.create({:form_name => "Exhibitor Contract - Non Profit"})
food_item_contract = Form.create({:form_name => "Exhibitor Contract of Food Items"})

advertising_non_sponsor_contract = Form.create({:form_name => "Advertising Contract"})
advertising_sponsor_contract = Form.create({:form_name => "Advertising Contract for Sponsors"})

health_permit_form = Form.create({:form_name => "Health Permit Form"})
restaurant_health_permit_form = Form.create({:form_name => "Health Permit Form for Restaurant Concessionaires"})

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

questions_for_form[non_food_contract] = [
	{:question => 'Product/Services Description',
		:question_type => :statement},
	{:question => 'Please provide a description of all items being displayed, promoted and/or sold, or N/A for none.',
		:question_type => :message},
	{:question => 'Non Food Guidelines
		We only allow vegan items that have not have been tested on animals, and are free of leather, 
		fur, gelatin, silk, wool or any other animal derivatives.',
		:question_type => :statement},
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
		:answers => '[Regular Booth "B" - Open Courtyard: Payment on or before Aug 15th ($150),
		Regular Booth "B" - Open Courtyard: Payment after Aug 15th ($250),
		Regular Booth "C" - Gallery Bldg: Payment on or before Aug 15th ($200),
		Regular Booth "C" - Gallery Bldg: Payment after Aug 15th ($300)]',
		:question_type => :radio_button},
	{:question => 'Additional Chair $5 Each', 
		:answers => "[0, 1 ($5), 2 ($10), 3 ($15), 4 ($20)]",
		:question_type => :radio_button},
	{:question => 'Will you need electricity? ($75 fee)',
		:answers => "[Yes ($75), No]",
		:question_type => :radio_button},
	{:question => 'If yes, please state electrical requirements (including watts and/or amps) and type of equipment you will be bringing.
		List Equipment & Watts (not to exceed 1920 watts or 16 amps). If no, write N/A',
		:question_type => :message}
]

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
		:answers => '[Payment on or before Aug 15th ($150),Payment after Aug 15th ($250)]',
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
		Principal Sponsor - $3000
		- Booth (12' x 8')
		- Prominent Exhibit Location
		- Two tables with two chairs
		- Name on all publicity
		- Full page ad in event program
		- Logo Link on SFVS website
		- Product Exclusivity

		Major Sponsor - $2000
		- Booth (12' x 8')
		- Two tables with two chairs
		- Name on special publicity
		- Half page ad in event program
		- Logo Link on SFVS website
 
		Associate Sponsor - $1000
		- Booth (8' x 8')
		- One tables with two chairs
		- Newsletter recognition
		- Quarter page ad in program

		Supporting Sponsor (non exhibiting) - $500
		- Newsletter recognition
		- Quarter page ad in program

		Included above are 6' x 2.5' table/s, chairs, health permits, and electricity (except non-exhibitor).",
		:question_type => :statement},
	{:question => 'Please select your Sponsorship type:',
		:answers => "[Principal Sponsor ($3000), Major Sponsor ($2000), Associate Sponsor ($1000), Supporting Sponsor (non exhibiting) ($500)]",
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
		:answers => '[Regular Booth "B" - Open Courtyard: Payment on or before Aug 15th ($150),
		Regular Booth "B" - Open Courtyard: Payment after Aug 15th ($250),
		Regular Booth "C" - Gallery Bldg: Payment on or before Aug 15th ($200),
		Regular Booth "C" - Gallery Bldg: Payment after Aug 15th ($300)]',
		:question_type => :radio_button},
	{:question => 'Additional Chair $5 Each', 
		:answers => "[0, 1 ($5), 2 ($10), 3 ($15), 4 ($20)]",
		:question_type => :radio_button},
	{:question => 'Will you need electricity? ($75 fee)',
		:answers => "[Yes ($75), No]",
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
		:answers => "[Payment on or before Aug 15th ($165), Payment after Aug 15th ($215)]",
		:question_type => :radio_button},
	{:question => 'Additional Chair $5 Each', 
		:answers => "[0, 1 ($5), 2 ($10), 3 ($15), 4 ($20)]",
		:question_type => :radio_button},
	{:question => 'Will you need electricity? ($75 fee)',
		:answers => "[Yes ($75), No]",
		:question_type => :radio_button},
	{:question => 'If yes, please state electrical requirements (including watts and/or amps) and type of equipment you will be bringing.
		List Equipment & Watts (not to exceed 1920 watts or 16 amps). If no, write N/A',
		:question_type => :message}
]

# Advertising Forms

questions_for_form[advertising_sponsor_contract] = 	[
	{:question => 'Ads - Program Book Size  8 1/2-in x 11-in (2,000 copies)
		All ads are one color (black print)',
		:question_type => :statement},
	{:question => 'Please select a size of your advertisement:',
		:answers => '[Full Page (8.5-in x 11-in), Half Page (8.5-in x 5.5-in), Quarter Page (4.25-in x 5.5-in)]',
		:question_type => :radio_button},
	{:question => 'Additional Information
		Deadline: July 1
		Minimum Specs: Tiff or PDF file; 1600 x 1200 pixels; 300 dpi

		Enclosed camera-ready ad/logo and mail to address below, or
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement}
	# {:question => 'Please upload here',
	# 	:question_type => :textbox},
]

questions_for_form[advertising_non_sponsor_contract] = 	[
	{:question => 'Ads - Program Book Size  8 1/2-in x 11-in (2,000 copies)
		All ads are one color (black print)',
		:question_type => :statement},
	{:question => 'Half Page (8.5-in x 5.5-in): $300',
		:answers => "[Yes ($300), No]",
		:question_type => :radio_button},
	{:question => 'Quarter Page (4.25-in x 5.5-in): $200',
		:answers => "[Yes ($200), No]",
		:question_type => :radio_button},
	{:question => 'One Eigth Page (4.25-in x 2.75-in): $100',
		:answers => "[Yes ($100), No]",
		:question_type => :radio_button},
	{:question => 'Business Card Size (3.5-in x 2-in): $50',
		:answers => "[Yes ($50), No]",
		:question_type => :radio_button},
	{:question => 'Additional Information
		Deadline: August 31
		Minimum Specs: Tiff or PDF file; 1600 x 1200 pixels; 300 dpi

		Enclosed camera-ready ad/logo and mail to address below, or
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement}
	# {:question => 'Please upload here',
	# 	:question_type => :textbox},
]

# Agreement Forms

questions_for_form[conditions_of_agreement] = [
	{:question => "Conditions of Agreement
		1. The Contract for participation shall not become a binding contract between the Exhibitor 
		and the San Francisco Vegetarian Society (hereafter referred to as SFVS) until the contract 
		has been signed by SFVS.

		2. Exhibitors shall be responsible for the setup and tear down of their own exhibit.
		All garbage shall be placed in appropriate trash containers and cardboard boxes must be broken apart for recycling.
		A $50 cleaning fee may be assessed to booths not left clean as determined by SFVS and may result 
		in Exhibitor's non-participation in future World Vegetarian Festival (WVF) celebration.

		3. No Exhibitor shall exhibit any merchandise or service other than that specified in the contract.
		The Exhibitor may not promote in their product display or literature any items that do not meet the SFVS
		food and / or non-food guidelines.Exhibit space shall not be sublet or shared without the permission of SFVS.
		
		4. The Exhibitor's property shall be placed on display and exhibited at the Exhibitor's own risk and neither SFVS
		nor the Recreation & Parks Dept of the City and County of San Francisco shall be responsible for the death or injury
		to any person or for damage, including consequential damages, or loss of property of the Exhibitor, its officers,
		agents, employees, or invitees resulting from any cause whatsoever and the Exhibitor hereby indemnifies and holds
		SFVS and / or City and County of San Francisco harmless for any suit, action or claim arising out of any action
		or failure to act by the Exhibitor.
		
		5. If the Exhibitor fails to comply in any respect with the terms, conditions, rules or regulations of this contract,
		all rights of the Exhibitor hereunder shall cease and terminate.
		
		6. Should any contingency interrupt or prevent the holding of the WVF Celebration, including but not limited to war,
		terrorism, acts of God, strikes, lockouts or other labor or individual disturbances, riots, failure to secure
		materials or labor, fire, lighting, tempest, flood, explosion or any other cause, then SFVS shall in no way whatsoever
		be liable to the Exhibitor.
		
		7. The Exhibitor will exhibit in a proper manner, and will keep the exhibit space open and staffed at all time during the
		WVF Celebration hours. SFVS reserves the right to restrict exhibits to a maximum noise level and to suitable methods of
		operation and display. SFVS shall have the final decision as to what constitutes a proper exhibit and such decision shall
		be final and binding.  If for any reason any exhibit or its contents are deemed objectionable by SFVS, the exhibit will be
		removed.  This provision includes persons, things, conduct, printed matter or any item or attire that SFVS may consider
		objectionable to the WVF Celebration's intent. SFVS further reserves the right to relocate exhibits or exhibitors when in
		its opinion such relocations are necessary to maintain the character and / or good order of the WVF Celebration.

		8. The Exhibitor agrees that no display may be dismantled or goods removed during the entire period of the agreed upon 
		time slot. The Exhibitor agrees also to remove its exhibit, equipment and other exhibit items from the grounds of the 
		WVF Celebration at the end of the agreed upon time slot. In the event of failure to do so, the Exhibitor agrees to
		pay for such additional costs as may be incurred.
		
		9. The Exhibitor shall not: (a) commit any nuisance; (b) cause any unusual or objectionable smoke or odor to emanate 
		from its space; (c) do anything which would interfere with the effectiveness of any utility, ventilating or 
		air-conditioning systems on the facilities of the WVF Celebration, nor interfere with free access or passage to
		the facilities of the WVF Celebration; (d) interfere with the effectiveness of or accessibility to the electrical,
		plumbing, gas or compressed air systems; (e) overload any floor, ceiling or wall; (f) do or permit to be done any 
		act which might invalidate any insurance policy carried by SFVS or the City and County of San Francisco.
		
		10. If the exhibit space is not occupied by the opening of the WVF Celebration, this will be considered as a no-show
		and the space will be deemed forfeited. This forfeited space may be resold, reassigned or used by the SFVS management
		without obligations on the part of SFVS for any refund whatsoever.
		
		11. The Exhibitor will confine its activities to the exhibit space allotted and will not solicit beyond the boundaries hereto.
		
		12. The SFVS reserves the right to decline any applications at its discretion.

		Upon the original or facsimile copy of this contract being accepted and signed by an authorized
		member of the SFVS, this becomes a binding agreement and the Company / Organization listed
		above is subject to and agrees with all conditions stated on the contract.  SFVS reserves the right
		to assign space in order to benefit the overall event.", 
		:answers => "[I Agree to the terms and conditions]",
		:question_type => :checkbox}
]

questions_for_form[make_agreement] = [
	{:question => 'Agreement:
		I certify that I have read the World Vegetarian Festival exhibitor information and contract
		and agree to all terms and guidelines specified therein.',
		:answers => "[I Agree to the terms and conditions]",
		:question_type => :checkbox},
	{:question => 'Company/Organization:', 
		:question_type => :textbox},
	{:question => "Name:",
		:question_type => :textbox},
	{:question => "Signature:",
		:question_type => :textbox},
	{:question => "Title:",
		:question_type => :textbox},
	{:question => "Date:",
		:question_type => :textbox}
]

# Health Permit Forms

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
		:answers => "[High risk city health permit ($207), Low risk city health permit ($105)]",
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
		:answers => "[High risk city health permit ($207)]",
		:question_type => :radio_button},
	{:question => 'Additional Information
		Email electronic copy to: wvdinfo@sfvs.org

		Mail Information: San Francisco Vegetarian Society,
		73 Rondel Place,
		San Francisco, CA 94103',
		:question_type => :statement}
]

questions_for_form[setup_instructions] = [
	{:question => "Set-up and Clean-up
		1. For your convenience, we have arranged a Friday set-up time from 2:00 - 4:00 p.m.
		
		2. On the day of the event, check-in and set-up time: 8:00 - 9:30 a.m. 
		Please complete set up by 9:30 a.m. After 9:30 a.m., SFVS reserves the right 
		to assign an empty booth without any further obligation.

		3. The building facilities will be locked the evenings of Friday and Saturday. 
		You may leave non-valuables items inside the Gallery. There are no security guards in the evening.

		4. Exhibitors' gallery must be vacated Sunday by 7:00 p.m.
		
		5. Area(s) rented must be swept and, if necessary, mopped at the end of each day. 
		Please bring your own brooms, mops and dust pans. A $50 cleaning fee may be assessed to booths 
		not left clean as determined by SFVS.
		
		6. SFVS has GARBAGE, RECYCLING and COMPOST dumpsters adequately marked behind the 
		building. Do not use the County Fair Building dumpster. Garbage must be taken with 
		ou on departure or placed in the marked SFVS dumpster located at the back of the Gallery building. 
		Cardboard boxes must be broken apart for recycling.

		7. Screws, tacks or tape must not be used to fasten items to walls, 
		cabinets,windowsills, doorways or ceiling. Scotch brand, blue painter's tape may be used.

		8. If you need to hang a heavy banner, you may need to supply your own banner 
		stands and you are advised to do your set-up on a Friday.

		9. Flyers, advertising or information materials can only be posted in the exhibitor's exhibit space.

		10. Loading and unloading is located at the Lincoln Way entrance. 
		No permanent parking allowed. These are reserved spaces and your vehicle 
		may be towed by the County Fair building management.

		11. Parking inside the park is limited to 4 hours. 
		You may park on Lincoln Way or at the UCSF garage (See directions page). 
		There is also a whole day public garage parking located in the Park by the Japanese Tea Garden.

		12. No propane gas tank is allowed for heating or cooking inside the building.

		13. No animals or pets are allowed inside the premises with the exception of 
		guide or service dogs or animals needed by the disabled.

		14. Emergency and first aid services will be provided at the SFVS Volunteer Booth 
		located at the middle of the Gallery.",

		:answers => "[I Agree to the terms and conditions]",
		:question_type => :checkbox}
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

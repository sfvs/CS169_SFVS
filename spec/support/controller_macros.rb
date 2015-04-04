module ControllerMacros
  
  # takes in a member_objects, authenticates it using a stub, and returns it
  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
    user
  end

  # current types are :user, and :admin
  # member_attributes is a hash of specific attrs. ex. {:email => "hello@world.com"}
  def make_a_member(type = :user, member_attributes = nil)
    @request.env["devise.mapping"] = Devise.mappings[type]
    FactoryGirl.create(type,member_attributes)
  end

  def make_many_members(type = :user, count = 5)
    @request.env["devise.mapping"] = Devise.mappings[type]
    user_list = []
    member_attributes = Hash.new
    (0..count-1).each do |i|
      member_attributes[:email] = "user" + i.to_s + "@hostname.com"
      user_list << FactoryGirl.create(type, member_attributes)
    end
    user_list
  end

  def make_a_form(form_name = "Form")
    form = FactoryGirl.create(:form, {:form_name => form_name})
  end

  def make_many_forms(count = 3)
    form_list = []
    (0..count-1).each do |i|
      form_list << make_a_form
    end
    form_list
  end

  def make_forms_for_app_type(type)
    type = FactoryGirl.create(:application_type,{:app_type => type})
    type.forms << make_many_forms
    type
  end

  def login(type = :user, attributes = nil)
    before(:each) do
      obj = sign_in make_a_member(type, attributes)
      if type == :user
        @user = obj
      elsif type == :admin
        @admin = obj
      end
    end
  end

  def make_question_answer_tree
    before :each do
      @q1 = Questionnaire.create(:question => "hello world")
      @q2 = Questionnaire.create(:question => "how are you?")
      @a1a = Answers.create(:ans => "hi", :questionnaire_id => @q1.id, :leads_to => @q2.id)
      @a1b = Answers.create(:ans => "hello", :questionnaire_id => @q1.id)
      @a2 = Answers.create(:ans => "I am world", :questionnaire_id => @q2.id)
      @q2.parent_id = @a1a.id
      @q2.save
    end
  end

end
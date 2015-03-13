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

  def login(type = :user)
    before(:each) do
      obj = sign_in make_a_member(type)
      if type == :user
        @user = obj
      elsif type == :admin
        @admin = obj
      end
    end
  end

end
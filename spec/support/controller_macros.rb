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

end
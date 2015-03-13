require 'spec_helper'

describe UsersController do
  describe "user validation" do
    it "works with valid logged in user" do
      user = sign_in make_a_member(:user, :email => "i_am_a_coconut@mail.com") 
      get :questionnaire, :id => user.id
    end

    it "should not work with bad id" do
      user = sign_in make_a_member(:user, :email => "i_am_a_coconut@mail.com") 
      get :questionnaire, :id => 15
    end
  end
end

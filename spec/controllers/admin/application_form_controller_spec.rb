require 'spec_helper'

describe Admin::ApplicationFormController do
  login :admin

  describe "show action" do

    before :each do
      @user = make_a_member :user, :email => "rspecftw@hostname.com"
    end

    make_a_vendor_application_for_user

    before :each do
      @user.reload
      @application = @user.applications[0]
      @form_name = @application.application_type.forms[0].form_name
    end

  end
end
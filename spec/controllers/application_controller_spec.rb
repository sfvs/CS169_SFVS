require 'spec_helper'

describe ApplicationController do
  describe "rescue_from ActiveRecord exception" do
    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end
  
    login :user

    it "rescues from RecordNotFound" do
      get :index
      response.should redirect_to(root_path)
    end
  end

  describe "rescue_from NotAuthorizedError exception" do
    controller do
      def index
        raise Pundit::NotAuthorizedError
      end
    end
  
    login :user

    it "rescues from RecordNotFound" do
      get :index
      response.should redirect_to(root_path)
      flash[:alert].should == "You are not authorized to perform this action."
    end
  end
end
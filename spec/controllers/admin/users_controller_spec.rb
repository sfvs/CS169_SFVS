require 'spec_helper'

describe Admin::UsersController do
  render_views
  login :admin

  describe "admin users page" do
    it "should assign @users to the list of regular users" do
        users = make_many_members
        get 'index'
        response.should be_success
        assigns(:users).should == users
    end

    it "should return a list of users' email addresses" do
        user = make_a_member(:user, :email => "shrek_is_love@shrek_is_life.com") 
        get 'index'
        expect(response.body).to include(user.email)
    end

    it "should have a 'Create User' button" do
        get 'index'
        expect(response.body).to include("Create User")
    end
  end

  describe "admin edit page" do
    it "returns http success" do
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'edit', :id => user.id
      response.should be_success
    end

    it "should assign @user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'edit', :id => user.id
      response.should be_success
      assigns(:user).should == user
    end
  end

  describe "admin show user content page" do
    it "returns http success" do
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'show', :id => user.id
      response.should be_success
    end

    it "should assign @user" do 
      user = make_a_member :user, :email => "user1@hostname.com"
      get 'show', :id => user.id
      response.should be_success
      assigns(:user).should == user
    end

    it "should assign @applications" do
      user = make_a_member :user, :email => "bravo@hostname.com"
      @type = make_forms_for_app_type "vendor"
      @mock_app = make_an_application @type, 2015
      user.applications << @mock_app
      user.save
      get 'show', :id => user.id
      response.should be_success
      user.reload
      assigns(:applications).should == user.applications
    end
  end

  describe "admin delete user" do
    it "should delete the user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      lambda do
        delete 'destroy', :id => user.id
      end.should change(User, :count).by(-1)
    end

    it "should redirect to admin users list page after deleting user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      delete 'destroy', :id => user.id
      response.should redirect_to '/admin/users'
    end
  end 

  describe "admin show user content page" do 
    it "should route to show user content page" do
      user = make_a_member :user
      expect(:get => "admin/users/#{user.id}").to route_to(:controller => "admin/users", :action => "show", :id => "#{user.id}")
    end
  end

  describe "admin user edit page" do
    it "should route to user edit page" do
      user = make_a_member :user
      expect(:get => "admin/users/#{user.id}/edit").to route_to(:controller => "admin/users", :action => "edit", :id => "#{user.id}")
    end
  end

  describe "admin edit user information" do
    it "should update the user" do
      user = make_a_member :user, :email => "user1@hostname.com"
      put 'update', :id => user.id, :user => {"company_name" => "Soy"}
      user = user.reload
      user.company_name.should == "Soy"
    end

    it "should redirect to user content page" do
      user = make_a_member :user, :email => "user1@hostname.com"
      put 'update', :id => user.id, :user => {"company_name" => "Soy"}
      response.should redirect_to '/admin/users/' + user.id.to_s
    end

    it "should assign the notice with success message" do
      user = make_a_member :user, :email => "user1@hostname.com"
      put 'update', :id => user.id, :user => {"company_name" => "Soy"}
      flash[:notice].should == "User #{user.email} has been updated."
    end
  end

  describe "admin create user page" do
    it "should route to create new user page" do
      expect(:get => "admin/users/new").to route_to(:controller => "admin/users", :action => "new")
    end

    it "should create a new regular user" do
      User.stub(:valid_email?).and_return(true)
      user_info = {:email => "new_user@gmail.com", :password => "user1234", :admin => false}
      post 'create', :user => user_info
      User.where("email=?", "new_user@gmail.com").first.should != nil
    end

    it "should create a new admin user" do
      User.stub(:valid_email?).and_return(true)
      user_info = {:email => "new_admin@gmail.com", :password => "admin123", :admin => true}
      post 'create', :user => user_info
      User.where("email=?", "new_admin@gmail.com").first.should != nil
    end

    it "should redirect to users list page" do
      User.stub(:valid_email?).and_return(true)
      user_info = {:email => "new_admin@gmail.com", :password => "admin123", :admin => true}
      post 'create', :user => user_info
      response.should redirect_to '/admin/users'
    end

    it "should redirect to new user creation page in case of invalid e-mail" do
      User.stub(:valid_email?).and_return(false)
      user_info = {:email => "platoisaman@admin.com", :password => "admin123", :admin => true}
      post 'create', :user => user_info
      response.should redirect_to '/admin/users/new'
    end

    it "should detect a used e-mail" do
      valid_email?("platoisaman@admin.com").should == false
    end
  end 

  describe "search user by e-mail" do
    it "should assign the alert with warning when invalid e-mail" do
      post 'search', :user_email => "invalid@email.com"
      flash[:alert].should == "No user with e-mail: invalid@email.com"
    end

    it "should route to users list page with invalid e-mail" do
      post 'search', :user_email => "invalid@email.com"
      response.should redirect_to '/admin/users'
    end

    it "should route to users list page with admin e-mail" do
      admin = make_a_member :admin, :email => "admin@gmail.com"
      post 'search', :user_email => "admin@gmail.com"
      response.should redirect_to '/admin/users'
    end

    it "should route to the user content page with valid e-mail" do
      user = make_a_member :user, :email => "user1@hostname.com"
      post 'search', :user_email => "user1@hostname.com"
      response.should redirect_to '/admin/users/' + user.id.to_s
    end
  end

  describe "filter users by year" do
    it "should assign @users with users with application of that year" do
      user = make_a_member :user, :email => "filterme@hostname.com"
      users_list = []
      users_list << user
      User.stub(:get_users_filtered_by).and_return(users_list)
      post 'filter', :app_year => 2015
      assigns(:users).should == users_list
    end

    it "should render the correct view" do
      user = make_a_member :user, :email => "filterme@hostname.com"
      User.stub(:get_users_filtered_by).and_return([user])
      post 'filter', :app_year => 2015
      expect(response).to render_template(:index)
    end
  end
end

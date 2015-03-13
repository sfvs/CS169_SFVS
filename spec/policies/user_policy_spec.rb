require 'spec_helper'
require 'pundit/rspec'

describe UserPolicy do
  subject { UserPolicy }

  permissions :is_admin? do
    it "denies access if user is a regular user" do
      expect(subject).not_to permit(User.new({:admin => false}, :without_protection => true), nil)
    end

    it "allows access if user is an admin" do
      current_user = User.create({:admin => true}, :without_protection => true)
      current_user.update_attribute :admin, true
      expect(subject).to permit(current_user, nil)
    end
  end

  permissions :is_regular_user? do
    it "denies access if user is an admin" do
      current_user = User.create({:admin => true}, :without_protection => true)
      current_user.update_attribute :admin, true
      expect(subject).not_to permit(current_user, nil)
    end

    it "allows access if user is regular user" do
      expect(subject).to permit(User.new({:admin => false}, :without_protection => true), nil)
    end
  end

  permissions :is_profile_owner? do
    it "allows access if current_user is the profile owner" do
      user = User.new({:admin => false}, :without_protection => true)
      expect(subject).to permit(user, user)
    end

    # Using FactoryGirl and ActiveRecord#create to create 2 users as each user has to have
    # a unique email address, therefore FactoryGirl cannot be used 2 times.
    it "denies access if current_user is not the profile owner" do
      owner_user = FactoryGirl.create(:user) 
      current_user = User.create({:admin => false}, :without_protection => true)
      expect(subject).not_to permit(current_user, owner_user)
    end
  end
end
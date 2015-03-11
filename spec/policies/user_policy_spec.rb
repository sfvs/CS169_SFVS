require 'spec_helper'
require 'pundit/rspec'

describe UserPolicy do
  subject { UserPolicy }
  
  permissions :is_admin? do
    it "denies access if user is a regular user" do
      expect(subject).not_to permit(User.new({:admin => false}, :without_protection => true), nil)
    end
  end
end
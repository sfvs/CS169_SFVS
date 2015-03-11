class UserPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def is_admin?
    @user.admin?
  end

  def is_regular_user?
    !@user.admin?
  end

  def is_profile_owner?
    @user.id == @record.id
  end
  
end


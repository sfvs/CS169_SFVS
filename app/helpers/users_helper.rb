module UsersHelper
  def user_exists?(id)
    User.exists?(id)
  end
end

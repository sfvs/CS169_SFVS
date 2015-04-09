class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_reader :admin
  # attr_accessible :title, :body

  has_many :applications
  def get_most_recent_application
    self.applications.where(year: Application.latest_year)[0]
  end
end

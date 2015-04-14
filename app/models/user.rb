class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :contact_person, :company_name, :telephone
  attr_reader :admin
  # attr_accessible :title, :body

  has_many :applications
  def get_most_recent_application
    self.applications.where(year: Application.current_application_year).first
  end
end

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

  # Need to set admin attr of users to false manually since migration's
  # setting of the default value of admin to false is not being applied
  # correctly.
  after_initialize do
    if self.new_record?
      if !self.admin || self.admin.nil?
        self.admin = false
      end
    end
  end
end

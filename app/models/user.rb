class User < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :contact_person, :company_name, :telephone
  attr_reader :admin
  # attr_accessible :title, :body
  before_save :format_phone_number

  has_many :applications, dependent: :destroy
  def get_most_recent_application
    self.applications.where(year: Application.current_application_year).first
  end

  def self.get_users_by_order(order)
    self.find(:all, :order => order, :conditions => {:admin => false})
  end

  def format_phone_number
    self.telephone = number_to_phone(self.telephone, area_code: true) unless self.telephone.nil?
  end

  def create_an_application(type)
    recent_application = self.get_most_recent_application
    if not recent_application.nil?
      recent_application.destroy
    end
    app = self.applications.create()
    app.application_type = type
    app.year = Application.current_application_year
    app.save
  end

end

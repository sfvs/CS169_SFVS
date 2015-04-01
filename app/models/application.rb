class Application < ActiveRecord::Base
  attr_accessible :user, :year, :app_type, :content, :completed
  belongs_to :user

  def self.get_application_types
    {
      :vendor => "1",
      :donor => "2",
      :restaurant_concessionaire => "3",
      :other => "4"
    }
  end

end

FactoryGirl.define do  factory :form do
    
  end
  factory :form_question do
    
  end

  factory :user do
    email "amanismortal@user.com"
    password "password"
    password_confirmation "password"
    admin false
  end

  # an admin is from the user class
  factory :admin, class: User do
    email "platoisaman@admin.com"
    password "password"
    password_confirmation "password"
    admin true
  end

end
FactoryGirl.define do  factory :payment do
    
  end
  

  factory :file_attachment do
    data 'some_content'
    content_type 'application/pdf'
    file_type "health_form"  
  end
  
  factory :application_type do
    app_type "vendor"
  end
  
  factory :form do
    form_name "General"
  end
  
  factory :form_question do
    question "How are you?"
    answers "[Good!,Great!,Wonderful!]"
    question_type :checkbox
    order 0
  end

  factory :application do
    year 2000
    content {}
    completed false
    approved false
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

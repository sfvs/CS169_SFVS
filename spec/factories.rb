FactoryGirl.define do  factory :answer, :class => 'Answers' do
    ans "MyText"
q_id 1
  end
  factory :questionnaire do
    question "MyText"
parent_id 1
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
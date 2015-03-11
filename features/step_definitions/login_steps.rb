# login steps
Given(/^the following users exist:$/) do |table|
  table.hashes.each do |user|
    User.create(user, :without_protection => true)
  end
end
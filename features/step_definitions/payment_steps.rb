Given(/^the following payments exist:$/) do |table|
  table.hashes.each do |item|
    Payment.create(item, :without_protection => true)
  end
end

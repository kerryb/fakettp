Given /^there are (\d*) expectations$/ do |count|
  count.to_i.times do
    Fakettp::Expectation.create! :contents => 'foo'
  end
end

Given /^there are (\d*) expectations$/ do |count|
  count.to_i.times do
    Fakettp::Expectation << ''
  end
end

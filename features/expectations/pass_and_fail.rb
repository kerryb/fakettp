expect "pass and fail" do
  (2 + 2).should == 4
  true.should be_false
  'will never get here'
end
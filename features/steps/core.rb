Given /^the simulator is reset$/ do
  req = Net::HTTP::Post.new '/reset'
  Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
end

Given /^we expect (\S*)$/ do |filename|
  req = Net::HTTP::Post.new '/expect', {'Content-Type' => 'text/plain'}
  req.body = File.read(File.dirname(__FILE__) + "/../expectations/#{filename}")
  Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
end

Then /^verifying the simulator should report success$/ do
  req = Net::HTTP::Get.new '/verify'
  resp = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
  resp.class.should == Net::HTTPOK
  resp.body.should == "OK\n"
end

Then /^verifying the simulator should report a failure, with message "(.*)"$/ do |message|
  req = Net::HTTP::Get.new '/verify'
  resp = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
  resp.class.should == Net::HTTPBadRequest
  resp.body.should =~ Regexp.new(message)
end

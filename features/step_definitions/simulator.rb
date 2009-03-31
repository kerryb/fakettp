Given /^the simulator is reset$/ do
  req = Net::HTTP::Post.new '/reset'
  Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
end

Given /^we expect (\S*)$/ do |filename|
  body = File.read(File.dirname(__FILE__) + "/../expectations/#{filename}")
  req = Net::HTTP::Post.new '/expect', {'Content-Type' => 'text/plain'}
  req.body = body
  Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
end

Then /^verifying the simulator should report success$/ do
  req = Net::HTTP::Get.new '/verify'
  resp = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
  resp.body.should == "Verify OK\n"
  resp.class.should == Net::HTTPOK
end

Then /^verifying the simulator should report a failure, with message "(.*)"$/ do |message|
  req = Net::HTTP::Get.new '/verify'
  resp = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
  resp.body.should =~ Regexp.new(message, Regexp::MULTILINE)
  resp.class.should == Net::HTTPInternalServerError
end

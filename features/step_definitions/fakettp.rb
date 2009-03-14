Given /^the simulator is reset$/ do
  req = Net::HTTP::Post.new '/reset'
  Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
end

Given /^we expect (\S*)$/ do |filename|
  body = File.read(File.dirname(__FILE__) + "/../expectations/#{filename}.rb")
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

When /^we request (\S*)$/ do |path|
  req = Net::HTTP::Get.new path
  @@response = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
end

Then /^the response should have a '(.*)' header with a value of '(.*)'$/ do |name, value|
  @@response[name].should == value
end

Then /^the response should have a content type of '(.*)'$/ do |value|
  @@response.content_type.should == value
end

Then /^the response should have a body of '(.*)'$/ do |value|
  @@response.body.should == value
end

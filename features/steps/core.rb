require 'httparty'

class FakeTTP
  include HTTParty
  base_uri 'fakettp.local'
end

Given /^the simulator is reset$/ do
  FakeTTP.post '/reset'
end

Given /^we expect (\S*)$/ do |filename|
  body = File.read(File.dirname(__FILE__) + "/../expectations/#{filename}")
  FakeTTP.post '/expect', :body => body, :headers => {'Content-Type' => 'text/plain'}
end

Then /^verifying the simulator should report success$/ do
  req = Net::HTTP::Get.new '/verify'
  resp = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
  resp.body.should == "OK\n"
  resp.class.should == Net::HTTPOK
end

Then /^verifying the simulator should report a failure, with message "(.*)"$/ do |message|
  req = Net::HTTP::Get.new '/verify'
  resp = Net::HTTP.new('fakettp.local').start {|http| http.request(req) }
  resp.body.should =~ Regexp.new(message, Regexp::MULTILINE)
  resp.class.should == Net::HTTPBadRequest
end

When /^we request (\S*)$/ do |path|
  FakeTTP.get path rescue nil
end


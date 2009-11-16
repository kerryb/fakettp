require 'nokogiri'

module HttpHelper
  def check_value locator, value
    node = Nokogiri::XML(@response.body).xpath(locator).first
    contents = case node
               when Nokogiri::XML::Element then node.inner_html
               when Nokogiri::XML::Attr then node.to_s
               when nil then ''
               else raise 'Unexpected node type'
               end
    contents.should == value
  end
end
World HttpHelper

When /^we get (\S*) on (\S*)$/ do |path, host|
  req = Net::HTTP::Get.new path
  @response = Net::HTTP.new(host).start {|http| http.request(req) }
end

When /^we post to (\S*) on (\S*)$/ do |path, host|
  req = Net::HTTP::Post.new path
  @response = Net::HTTP.new(host).start {|http| http.request(req) }
end

When /^we print the response$/ do
  puts @response
end

Then /^the response should have a '(.*)' header with a value of '(.*)'$/ do |name, value|
  @response[name].should == value
end

Then /^the response should have a content type of '(.*)'$/ do |value|
  @response.content_type.should == value
end

Then /^the response body should be '(.*)'$/ do |value|
  @response.body.should == value
end

Then /^the response body should contain '(.*)'$/ do |value|
  @response.body.should include(value)
end

Then /^(\S*) in the response should be '(.*)'$/ do |locator, value|
  check_value locator, value
end

Then /^(\S*) in the response should be:$/ do |locator, value|
  check_value locator, value
end

Then /^there should be (\d*) (.*) elements in the response$/ do |count, locator|
  Nokogiri::XML(@response.body).xpath(locator).size.should == count.to_i
end

When /^we get (\S*) on (\S*)$/ do |path, host|
  req = Net::HTTP::Get.new path
  @@response = Net::HTTP.new(host).start {|http| http.request(req) }
end
When /^we post to (\S*) on (\S*)$/ do |path, host|
  req = Net::HTTP::Post.new path
  @@response = Net::HTTP.new(host).start {|http| http.request(req) }
end

Then /^the response should have a '(.*)' header with a value of '(.*)'$/ do |name, value|
  @@response[name].should == value
end

Then /^the response should have a content type of '(.*)'$/ do |value|
  @@response.content_type.should == value
end

Then /^the response body should be '(.*)'$/ do |value|
  @@response.body.should == value
end

Then /^the response body should contain '(.*)'$/ do |value|
  @@response.body.should include(value)
end

Then /^(\S*) in the response should be '(.*)'$/ do |xpath, value|
  xml_node_values(@@response.body, xpath).should include(value)
end

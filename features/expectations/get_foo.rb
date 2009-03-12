expect "GET /foo" do |request, response|
  request.path_info.should == '/foo'
end
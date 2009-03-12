expect "GET /" do |request, response|
  request.path_info.should == '/'
end
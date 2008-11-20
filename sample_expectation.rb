expect "Dummy request" do
  request.host.should == 'httpfake.local'
  request.path_info.should == '/foo'
  and_return do
    content_type 'text/plain'
    'All is well'
  end
end
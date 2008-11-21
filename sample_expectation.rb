expect "Dummy request" do
  request.host.should == 'httpfake.local'
  request.path_info.should == '/foo'

  content_type 'text/plain'
  "All is well\n"
end
expect "Set header" do |request, response|
  response['foo'] = 'bar'
end
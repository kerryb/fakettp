# $:.unshift(File.dirname(__FILE__))

Dir.glob(File.dirname(__FILE__) + '/**/*.rb').each do |f|
  require f
end
# 
# require 'fakettp/helper'
# require 'fakettp/commands/fakettp_command'
# require 'fakettp/controller'
# require 'fakettp/expectation'

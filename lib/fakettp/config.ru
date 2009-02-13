require 'rubygems'

FAKETTP_BASE = File.expand_path(File.dirname(__FILE__))
require 'fakettp'

run Sinatra.application

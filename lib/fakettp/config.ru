require 'rubygems'
#require 'sinatra/lib/sinatra.rb'
require 'sinatra'
 
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :raise_errors => true
)
 
log = File.new("fakettp.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)
 
FAKETTP_BASE = File.expand_path(File.dirname(__FILE__))
require 'fakettp'

run Sinatra::Application

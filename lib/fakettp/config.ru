require 'rubygems'
require 'sinatra'

Sinatra::Default.set :run, false
Sinatra::Default.set :environment, :production
Sinatra::Default.set :raise_errors, true

log = File.new("fakettp.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

FAKETTP_BASE = File.expand_path(File.dirname(__FILE__))
require 'fakettp'

run Sinatra::Application

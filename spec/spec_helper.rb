require 'rubygems'
require 'spec'
require 'sinatra'
require 'spec/interop/test'
require 'sinatra/test'
require 'active_record'
require 'shoulda/active_record'

set :environment, :test

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib/fakettp'))

FAKETTP_BASE = File.join(File.dirname(__FILE__), '..', 'tmp', 'install')
FileUtils.rm_rf FAKETTP_BASE
require 'fakettp/commands/fakettp_command'
Fakettp::Commands::FakettpCommand.new(['install', FAKETTP_BASE, 'fakettp.local']).run

require 'fakettp'

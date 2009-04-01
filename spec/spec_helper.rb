require 'rubygems'
gem 'rspec'
require 'spec'
require 'sinatra'
require 'spec/interop/test'
require 'sinatra/test'
require 'active_record'
require 'shoulda/active_record'

set :environment, :test

FAKETTP_BASE = File.join(File.dirname(__FILE__), '..', 'tmp', 'install')
require File.join(File.dirname(__FILE__), '..', 'lib', 'fakettp')

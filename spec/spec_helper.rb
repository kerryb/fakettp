require 'rubygems'
gem 'rspec'
require 'spec'
require 'sinatra'
require 'spec/interop/test'
require 'sinatra/test'

set :environment, :test

FAKETTP_BASE = File.join(File.dirname(__FILE__), '..', 'tmp', 'install')
require File.join(File.dirname(__FILE__), '..', 'lib', 'fakettp')

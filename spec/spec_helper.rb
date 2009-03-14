require 'rubygems'
gem 'rspec'
require 'spec'
require 'sinatra'
require 'spec/interop/test'
require 'sinatra/test'

FAKETTP_BASE = File.join(File.dirname(__FILE__), '..', 'tmp')
require File.join(File.dirname(__FILE__), '..', 'lib', 'fakettp')

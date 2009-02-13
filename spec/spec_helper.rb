require 'rubygems'
gem 'rspec'
require 'spec'

FAKETTP_BASE = File.join(File.dirname(__FILE__), '..', 'tmp')
require File.join(File.dirname(__FILE__), '..', 'lib', 'fakettp')

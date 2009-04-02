require 'fakettp/db'

module Fakettp
  class Expectation < ActiveRecord::Base
    set_table_name :expectations
    has_many :errors
    
    class Error < Exception; end
            
    def render
      contents
    end
    
    def execute binding
      self.executed = true
      save
      eval contents, binding
      # TODO: Include context of expectation file
    end
        
    def self.all_received?
      !exists? :executed => false
    end
    
    def self.next
      next_expectation = find_by_executed(false)
      raise Error.new('Received unexpected request') unless next_expectation
      next_expectation
    end
  end
end

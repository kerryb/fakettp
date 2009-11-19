require 'fakettp/db'

module Fakettp
  class Expectation < ActiveRecord::Base
    set_table_name :expectations
    # TODO Why has_many? There can be only one!
    has_many :errors

    class Error < StandardError
      attr_reader :line_number
      def initialize message, line_number = nil
        @line_number = line_number
        super(message)
      end
    end

    def execute binding
      self.executed = true
      save
      eval contents, binding
      # TODO: Include context of expectation file
    end

    def status
      if executed
        errors.empty? ? 'pass' : 'fail'
      else
        'pending'
      end
    end

    def self.all_received?
      !exists? :executed => false
    end

    def self.next
      find_by_executed(false)
    end
  end
end

require 'fakettp/expectation'
require 'fakettp/error'

module Fakettp
  class Simulator
    def self.reset
      Expectation.delete_all
      Error.delete_all
    end

    def self.verify
      Error.create!(:message => 'Expected request not received') unless Expectation.all_received?
      return !Error.exists?
    end

    def self.<< expectation
      Expectation.create! :contents => expectation
    end

    def self.handle_request binding
      expectation = Expectation.next
      if expectation
        begin
          expectation.execute binding
        rescue Fakettp::Expectation::Error => e
          expectation.errors.create :message => e.message, :line_number => e.line_number
          raise e
        end
      else
        Error.create! :message => 'Received unexpected request'
        raise Expectation::Error.new('Received unexpected request')
      end
    end

    def self.list_errors
      Error.list
    end
  end
end

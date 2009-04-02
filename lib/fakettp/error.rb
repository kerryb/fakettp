module Fakettp
  class Error < ActiveRecord::Base
    belongs_to :expectation
        
    def self.list
      errors = Error.all
      return '' if errors.empty?
      errors.map {|e| e.message}.join("\n") + "\n"
    end
  end
end

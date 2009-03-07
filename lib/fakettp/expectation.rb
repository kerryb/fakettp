require 'spec'

module Fakettp
  class Expectation
    class Error < RuntimeError; end
    
    EXPECTATION_DIR = File.join FAKETTP_BASE, 'tmp', 'expectations'
    
    def initialize contents
      @contents = contents
    end
    
    def execute request
      @request = request
      eval @contents
    end
    
    def self.clear_all
      FileUtils.rm_rf Dir.glob(File.join(EXPECTATION_DIR, '*'))
    end
    
    def self.empty?
      files.empty?
    end
    
    def self.<< expectation
      File.open next_file_to_create, 'w' do |f|
        f.write expectation
      end
    end
    
    def self.next
      file = next_file_to_read
      contents = File.read file
      FileUtils.rm file
      Expectation.new contents
    end
    
    def expect label
      begin
        yield @request
      rescue Exception => e
        raise Error, "Error in #{label}: #{e.message}", nil
      end
    end
    
    private
    
    def self.next_file_to_create
      name = (files.last.to_i + 1).to_s
      File.join EXPECTATION_DIR, name
    end
    
    def self.next_file_to_read
      name = files.first
      raise Error.new('Received unexpected request') unless name
      File.join EXPECTATION_DIR, name
    end
    
    def self.files
      Dir.entries(EXPECTATION_DIR) - ['.', '..']
    end
  
    private_class_method :next_file_to_create, :next_file_to_read, :files
  end
end

module Fakettp
  class Expectation
    class Error < Exception; end
    
    EXPECTATION_DIR = File.join FAKETTP_BASE, 'tmp', 'expectations'
    
    attr_reader :id
    
    def initialize id, contents
      @id, @contents = id, contents
    end
    
    def render
      @contents
    end
    
    def execute binding
      eval @contents, binding
      # TODO: Include context of expectation file
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
    
    def self.all
      files.map do |f|
        contents = File.read(File.join(EXPECTATION_DIR, f))
        Expectation.new f, contents
      end
    end
    
    def self.next
      file = next_file_to_read
      contents = File.read file
      FileUtils.rm file
      Expectation.new File.basename(file).to_i, contents
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
      (Dir.entries(EXPECTATION_DIR) - ['.', '..']).sort
    end
  
    private_class_method :next_file_to_create, :next_file_to_read, :files
  end
end

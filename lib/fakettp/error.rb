module Fakettp
  class Error
    ERROR_DIR = File.join FAKETTP_BASE, 'tmp', 'errors'
    
    def initialize expectation, line_no, message
      @expectation = expectation
      @line_no = line_no
      @message = message
    end
    
    def self.clear_all
      FileUtils.rm_rf Dir.glob(File.join(ERROR_DIR, '*'))
    end
    
    def self.add expectation, line_no, message
      File.open File.join(ERROR_DIR, "#{expectation}-#{line_no}"), 'w' do |f|
        f.puts message
      end
    end
    
    def self.empty?
      Dir.glob(File.join(ERROR_DIR, '*')).empty?
    end
    
    def self.list
      return [] if empty?
      Dir.glob(File.join(ERROR_DIR, '*')).map do |file|
        expectation = File.basename(file).sub(/-.*/, '').to_i
        line_no = File.basename(file).sub(/.*-/, '').to_i
        message = File.read(file).chomp
        Error.new expectation, line_no, message
      end
    end
  end
end

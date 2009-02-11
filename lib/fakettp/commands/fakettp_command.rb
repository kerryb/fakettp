module Fakettp
  module Commands
    module FakettpCommand
      def initialize args
        @args = args
      end
  
      def run
        command = get_command
        return usage unless command
        return 0
      end
  
      private
  
      def get_command
        @args[0]
      end
  
      def usage
        STDERR.puts "No!"
        return 1
      end
    end
  end
end
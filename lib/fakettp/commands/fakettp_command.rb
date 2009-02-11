module Fakettp
  module Commands
    class FakettpCommand
      def initialize args
        @args = args
      end
  
      def run
        command = get_command
        return usage unless command
        case command
        when 'install' then
          return install
        end
        return 0
      end
  
      private
  
      def get_command
        @args[0]
      end
      
      def install
        usage
      end
  
      def usage
        $stderr.puts <<-EOF
Usage:

  [TODO]
EOF
        return 1
      end
    end
  end
end
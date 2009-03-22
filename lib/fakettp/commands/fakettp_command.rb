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
        else
          return usage
        end
      end
  
      private
  
      def get_command
        @args[0]
      end
      
      def install
        dir = get_dir
        return usage unless dir
        if File.exist? dir
          $stderr.puts "File or directory #{dir} already exists."
          return 1
        end
        FileUtils.mkdir_p dir + '/tmp/expectations', :mode => 0777
        FileUtils.mkdir_p dir + '/public'
        FileUtils.cp File.dirname(__FILE__) + '/../config.ru', dir
        FileUtils.cp File.dirname(__FILE__) + '/../../../README.html', dir
        FileUtils.cp File.dirname(__FILE__) + '/../public/fakettp.css',
            dir + '/public'
        return 0
      end
      
      def get_dir
        @args[1]
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
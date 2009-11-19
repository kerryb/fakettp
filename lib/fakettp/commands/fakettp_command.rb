module Fakettp
  module Commands
    class FakettpCommand
      def initialize args
        @args = args
      end

      def run
        command = @args[0]
        return usage unless command
        case command
        when 'install' then
          return install
        else
          return usage
        end
      end

      private

      def install
        @directory, @hostname = @args[1..2]
        return usage unless @directory && @hostname
        if File.exist? @directory
          $stderr.puts "File or directory #{@directory} already exists."
          return 1
        end
        copy_files
        write_config
        create_database
        return 0
      end

      def copy_files
        FileUtils.mkdir_p @directory + '/tmp', :mode => 0777
        FileUtils.mkdir_p @directory + '/public'
        FileUtils.cp File.dirname(__FILE__) + '/../config.ru', @directory
        FileUtils.cp File.dirname(__FILE__) + '/../public/fakettp.css', @directory + '/public'
      end

      def write_config
        config = {'database' => {'adapter' => 'sqlite3', 'database' => 'fakettp.sqlite3'},
          'hostname' => @hostname
        }
        File.open @directory + '/fakettp.yml', 'w' do |file|
          file.write config.to_yaml
        end
      end

      def create_database
        system %(ruby -e "FAKETTP_BASE = '#{@directory}';load '#{File.dirname(__FILE__)}/../schema.rb'")
      end

      def usage
        $stderr.puts <<-EOF
Usage:

  fakettp install <directory> <hostname>

EOF
        return 1
      end
    end
  end
end

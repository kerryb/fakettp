require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

shared_examples_for 'incorrect usage' do
  it 'completes with non-zero status' do
    @command.run.should_not == 0
  end

  it 'prints a usage method to stderr' do
    @command.run
    @local_std_error.string.should =~ /Usage:/
  end
end

describe Fakettp::Commands::FakettpCommand do
  before do
    @orig_stderr = $stderr
    @local_std_error = StringIO.new
    $stderr = @local_std_error
  end

  after do
    $stderr = @orig_stderr
    @local_std_error.close
  end

  describe 'with no arguments' do
    before do
      @command = Fakettp::Commands::FakettpCommand.new([])
    end

    it_should_behave_like 'incorrect usage'
  end

  describe "with 'install'" do
    describe 'but no directory' do
      before do
        @command = Fakettp::Commands::FakettpCommand.new(['install'])
      end

      it_should_behave_like 'incorrect usage'
    end

    describe 'and a directory' do
      before :all do
        @dir = File.expand_path(File.dirname(__FILE__) + '../../../tmp/install_test')
      end

      describe 'but no hostname' do
        before do
          @command = Fakettp::Commands::FakettpCommand.new(['install', @dir])
        end

        it_should_behave_like 'incorrect usage'
      end

      describe 'and a hostname' do
        before :all do
          @hostname = 'fakettp.local'
          FileUtils.rm_rf @dir
          @command = Fakettp::Commands::FakettpCommand.new(['install', @dir, @hostname])
        end

        after :all do
          FileUtils.rm_rf @dir
        end

        describe 'when the directory already exists' do
          before :all do
            FileUtils.mkdir_p @dir
          end

          it 'completes with non-zero status' do
            @command.run.should_not == 0
          end

          it 'prints an error message to stderr' do
            @command.run
            @local_std_error.string.should =~ /already exists/
          end
        end

        describe 'when the directory does not exist' do
          before :all do
            @status = @command.run
          end

          it 'creates the directory' do
            File.should be_a_directory(@dir)
          end

          it 'copies the correct files to the directory' do
            Dir.glob(@dir + '/**/*').reject {|f| f =~ /sqlite3$/}.sort.should ==
              ['config.ru', 'fakettp.yml', 'public', 'public/fakettp.css',
                'tmp'].sort.map {|f| "#{@dir}/#{f}"}
          end

          it 'writes the database details and hostname to fakettp.yml' do
            YAML.load(File.read(@dir + '/fakettp.yml')).should == {
              'database' => {'adapter' => 'sqlite3', 'database' => 'fakettp.sqlite3'},
              'hostname' => @hostname
            }
          end

          it "makes the tmp directory world-read/writeable" do
            (File.stat(@dir + "/tmp").mode & 0777).should == 0777
          end

          it 'creates the database' do
            run_from = File.dirname(__FILE__) + '/../../../lib'
            `cd #{run_from};ruby -e "FAKETTP_BASE = '#{File.expand_path(@dir)}';require 'fakettp/expectation';p Fakettp::Expectation.new"`.should =~ /executed: false/
          end

          it 'completes with zero status' do
            @status.should == 0
          end
        end
      end
    end
  end

  describe 'with an unrecognised command' do
    before do
      @command = Fakettp::Commands::FakettpCommand.new(['wibble'])
    end

    it_should_behave_like 'incorrect usage'
  end
end

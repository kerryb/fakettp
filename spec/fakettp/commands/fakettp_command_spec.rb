require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

shared_examples_for 'incorrect usage' do
  it 'should complete with non-zero status' do
    @command.run.should_not == 0
  end
  
  it 'should print a usage method to stderr' do
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
      before do
        @dir = File.dirname(__FILE__) + '/foo'
        @command = Fakettp::Commands::FakettpCommand.new(['install', @dir])
      end
      
      after do
        FileUtils.rm_rf @dir
      end
      
      describe 'when the directory already exists' do
        before do
          FileUtils.mkdir_p @dir
        end
      
        it 'should complete with non-zero status' do
          @command.run.should_not == 0
        end
        
        it 'should print an error message to stderr' do
          @command.run
          @local_std_error.string.should =~ /already exists/
        end
      end
      
      describe 'when the directory does not exist' do
        it 'should create the directory' do
          @command.run
          File.should be_a_directory(@dir)
        end
        
        it 'should copy the correct files to the directory' do
          @command.run
          Dir.glob(@dir + '/**/*').sort.should == [@dir + '/config.ru', @dir + '/README.html',
              @dir + '/public', @dir + '/tmp', @dir + '/tmp/expectations'].sort
        end
        
        ['tmp', 'tmp/expectations'].each do |dir|
          it "should make the #{dir} directory world-read/writeable" do
            @command.run
            (File.stat(@dir + "/#{dir}").mode & 0777).should == 0777
          end
        end
    
        it 'should complete with zero status' do
          @command.run.should == 0
        end
      end
    end
  end
end

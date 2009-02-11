require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

shared_examples_for 'incorrect usage' do
  it 'should complete with status 1' do
    @command.run.should == 1
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
    describe 'with no directory' do
      before do
        @command = Fakettp::Commands::FakettpCommand.new(%w(install))
      end

      it_should_behave_like 'incorrect usage'
    end
  end
end

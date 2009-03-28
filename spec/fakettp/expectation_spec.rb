require File.dirname(__FILE__) + '/../spec_helper'

# TODO: factor out persistence

describe Fakettp::Expectation do
  before :all do
    @expectation_dir = File.join FAKETTP_BASE, 'tmp', 'expectations'
    @next_expectation_file = File.join FAKETTP_BASE, 'tmp', 'next_expectation'
    FileUtils.mkdir_p @expectation_dir
    FileUtils.rm_rf @next_expectation_file
  end
  
  def setup_files count = nil
    FileUtils.rm_rf Dir.glob(File.join(@expectation_dir, '*'))
    if count
      (1..count).each do |name|
        FileUtils.touch File.join(@expectation_dir, name.to_s)
      end
    end
  end
  
  def set_next_expectation number
    File.open @next_expectation_file, 'w' do |f|
      f.puts number
    end
  end
  
  describe 'clearing all expectations' do
    before do
      setup_files 2
    end
    
    it 'should remove the contents of tmp/expectations' do
      Fakettp::Expectation.clear_all
      Dir.glob(File.join(@expectation_dir, '**', '*')).should be_empty
    end
    
    it 'should remove the next_expectation file' do
      FileUtils.touch @next_expectation_file
      Fakettp::Expectation.clear_all
      File.exists?(@next_expectation_file).should be_false
    end
  end
  
  describe 'checking whether all expected requests have been received' do
    describe 'when there are no expectations' do
      before do
        setup_files
        FileUtils.rm_rf @next_expectation_file
      end
      
      it 'should return true' do
        Fakettp::Expectation.should be_all_received
      end
    end

    describe 'when the next expectation file points to an expectation' do
      before do
        setup_files 2
        set_next_expectation 2
      end
      
      it 'should return false' do
        Fakettp::Expectation.should_not be_all_received
      end
    end

    describe 'when the next expectation file does not point to an expectation' do
      before do
        setup_files 2
        set_next_expectation 3
      end
      
      it 'should return false' do
        Fakettp::Expectation.should be_all_received
      end
    end
  end
  
  describe 'getting all expectations' do
    it 'should return all expectations' do
      setup_files 2
      expectations = Fakettp::Expectation.all
      expectations.size.should == 2
      expectations.should be_all { instance_of?(Fakettp::Expectation) }
    end
  end
  
  describe 'adding an expectation' do
    describe 'when there are existing expectations' do
      before do
        setup_files 2
      end
    
      it 'should copy the supplied code to the next numbered expectation' do
        expectation = "foo\nbar"
        Fakettp::Expectation << expectation
        File.read(File.join(@expectation_dir, '3')).should == expectation
      end
      
      it 'should not assume that Dir.entries returns filenames in order' do
        Dir.stub!(:entries).and_return ['.', '2', '..', '1']
        expectation = "foo\nbar"
        Fakettp::Expectation << expectation
        File.read(File.join(@expectation_dir, '3')).should == expectation
      end
    end
    
    describe 'when there are no existing expectations' do
      before do
        setup_files
      end

      it 'should start at 1' do
        expectation = "foo\nbar"
        Fakettp::Expectation << expectation
        File.read(File.join(@expectation_dir, '1')).should == expectation
      end
    end
  end
  
  describe 'getting the next expectation' do
    describe 'when there are remaining expectations' do
      before do
        setup_files 2
        set_next_expectation 2
        @contents = "foo\nbar"
        File.open File.join(@expectation_dir, '2'), 'w' do |f|
          f.write @contents
        end
      end
  
      it 'should return an expectation with the contents of the next file' do
        expectation = stub :expectation
        Fakettp::Expectation.stub!(:new).with(2, @contents).and_return expectation
        Fakettp::Expectation.next.should == expectation
      end
      
      it 'should increment the next expectation file' do
        Fakettp::Expectation.next
        File.read(@next_expectation_file).chomp.should == '3'
      end
    end

    describe 'when there are no remaining expectations' do
      before do
        setup_files 2
        set_next_expectation 3
      end
      
      it 'should raise an error' do
        lambda { Fakettp::Expectation.next }.should raise_error(Fakettp::Expectation::Error,
            'Received unexpected request')
      end
    end

    describe 'when there is no next expectation file' do
      before do
        FileUtils.rm_rf @next_expectation_file
      end

      describe 'when expectaton 1 exists' do
        before do
          setup_files 1
        end
      
        it 'should return the first expectation' do
          expectation = stub :expectation
          Fakettp::Expectation.stub!(:new).with(1, an_instance_of(String)).and_return expectation
          Fakettp::Expectation.next.should == expectation
        end
      end

      describe 'when expectaton 1 does not exist' do
        before do
          setup_files
        end
      
        it 'should raise an error' do
          lambda { Fakettp::Expectation.next }.should raise_error(Fakettp::Expectation::Error,
              'Received unexpected request')
        end
      end
    end

    describe 'when there are no remaining expectations' do
      before do
        setup_files 2
        set_next_expectation 3
      end
      
      it 'should raise an error' do
        lambda { Fakettp::Expectation.next }.should raise_error(Fakettp::Expectation::Error,
            'Received unexpected request')
      end
    end
    
    it 'should order expectations as integers, not strings' do
      setup_files 11
      set_next_expectation 1
      Fakettp::Expectation.next
      File.read(@next_expectation_file).chomp.should == '2'
    end
  end
  
  it 'should allow access to its ID' do
    Fakettp::Expectation.new(1, 'foo').id.should == 1
  end
  
  describe 'rendering itself' do
    it 'should show its contents' do
      Fakettp::Expectation.new(1, 'foo').render.should == 'foo'
    end
  end
  
  describe 'executing' do
    it 'should eval the expectation code in the context of the supplied binding' do
      def getBinding(n)
        return binding
      end
      Fakettp::Expectation.new(1, 'n + 2').execute(getBinding(2)).should == 4
    end
  end
end

describe Fakettp::Expectation::Error do
  it 'should record the expectation that caused it' do
    Fakettp::Expectation::Error.new(1, 2, 'foo').expectation.should == 1
  end
  
  it 'should record the line number that failed' do
    Fakettp::Expectation::Error.new(1, 2, 'foo').line_no.should == 2
  end
  
  it 'should record a message' do
    Fakettp::Expectation::Error.new(1, 2, 'foo').message.should == 'foo'
  end
end

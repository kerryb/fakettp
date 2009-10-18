require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fakettp::Expectation do
  before do
    Fakettp::Expectation.delete_all
  end
  
  it 'is an ActiveRecord' do
    Fakettp::Expectation.new.should be_a_kind_of(ActiveRecord::Base)
  end
  
  it { should have_db_column(:contents).of_type(:text) }

  it { should have_db_column(:executed).of_type(:boolean) }
  
  it { should have_many(:errors) }
    
  it 'starts out unexecuted' do
    Fakettp::Expectation.create.executed.should be_false
  end
  
  describe 'checking whether all expected requests have been received' do
    describe 'when there are no expectations' do
      before do
        Fakettp::Expectation.delete_all
      end
      
      it 'returns true' do
        Fakettp::Expectation.should be_all_received
      end
    end

    describe "when there are expectations that haven't been run" do
      before do
        Fakettp::Expectation.create! :executed => true
        Fakettp::Expectation.create! :executed => false
      end
      
      it 'returns false' do
        Fakettp::Expectation.should_not be_all_received
      end
    end

    describe "when all expectations have been run" do
      before do
        Fakettp::Expectation.create! :executed => true
        Fakettp::Expectation.create! :executed => true
      end
      
      it 'returns true' do
        Fakettp::Expectation.should be_all_received
      end
    end
  end
  
  describe 'getting the next expectation' do
    describe 'when there are expectations' do
      before do
        @expectation_1 = Fakettp::Expectation.create :executed => true
        @expectation_2 = Fakettp::Expectation.create :executed => false
        @expectation_3 = Fakettp::Expectation.create :executed => false
      end
  
      it 'returns the first unexecuted expectation' do
        Fakettp::Expectation.next.should == @expectation_2
      end
    end

    describe 'when there are no expectations' do
      before do
        Fakettp::Expectation.delete_all
      end
      
      it 'returns nil' do
        Fakettp::Expectation.next.should be_nil
      end
    end
  end
  
  describe 'rendering itself' do
    before do
      @expectation = Fakettp::Expectation.new(:contents => 'foo')
    end

    describe 'when not executed' do
      it 'shows its contents' do
        @expectation.render.should == 'foo'
      end
    end

    describe 'when executed successfully' do
      before do
        @expectation.executed = true
      end

      it %(shows its contents in a 'pass' span) do
        @expectation.render.should == '<span class="pass">foo</span>'
      end
    end

    describe 'when executed with errors' do
      before do
        @expectation.executed = true
        @expectation.errors = [Fakettp::Error.new]
      end

      it %(shows its contents in a 'fail' span) do
        @expectation.render.should == '<span class="fail">foo</span>'
      end
    end
  end

  describe 'executing' do
    it 'evals the expectation code in the context of the supplied binding' do
      def getBinding(n)
        return binding
      end
      Fakettp::Expectation.new(:contents => 'n + 2').execute(getBinding(2)).should == 4
    end

    it 'marks itself as executed' do
      expectation = Fakettp::Expectation.create! :contents => ''
      expectation.execute binding
      expectation.reload
      expectation.executed.should be_true
    end
  end
end

describe Fakettp::Expectation::Error do
  it 'stores a message' do
    Fakettp::Expectation::Error.new('foo', 2).message.should == 'foo'
  end
  
  it 'stores a line number' do
    Fakettp::Expectation::Error.new('foo', 2).line_number.should == 2
  end
  
  it 'defaults the line number to nil' do
    Fakettp::Expectation::Error.new('foo').line_number.should be_nil
  end
end

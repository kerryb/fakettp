require File.dirname(__FILE__) + '/../spec_helper'
require 'hpricot'

describe 'Controller' do
  include Sinatra::Test
  before :all do
    @host = YAML.load(File.read(FAKETTP_BASE + '/fakettp.yml'))['hostname']
  end

  before do
    Fakettp::Simulator.reset
  end
  
  it 'mixes in Fakettp::ExpectationHelper' do
    Sinatra::Application.included_modules.should include(Fakettp::ExpectationHelper)
  end
  
  describe 'posting to /reset' do
    before do
      Fakettp::Simulator.stub! :reset
    end

    describe 'on the fakettp host' do
      def do_post
        post '/reset', nil, :host => @host
      end

      it 'resets the simulator' do
        Fakettp::Simulator.should_receive :reset
        do_post
      end

      it 'is successful' do
        do_post
        @response.should be_ok
      end

      it 'returns a plain text response' do
        do_post
        @response.content_type.should == 'text/plain'
      end

      it 'returns an acknowledgement message' do
        do_post
        @response.body.should == "Reset OK\n"
      end
    end
    
    describe 'on another host' do
      it 'acts like any other simulated request' do
        post '/reset', nil, :host => 'foo.fake.local'
        response.body.should == "Simulator received mismatched request\n"
      end
    end
  end

  describe 'posting an expectation to /expect' do
    before do
      @body = 'foo'
      Fakettp::Simulator.stub! :<<
    end

    describe 'on the fakettp host' do
      def do_post
        post '/expect', @body, :host => @host
      end

      it 'sets a simulator expectation using the request body' do
        Fakettp::Simulator.should_receive(:<<).with @body
        do_post
      end

      it 'is successful' do
        do_post
        @response.should be_ok
      end

      it 'returns a plain text response' do
        do_post
        @response.content_type.should == 'text/plain'
      end

      it 'returns an acknowledgement message' do
        do_post
        @response.body.should == "Expect OK\n"
      end
    end
    
    describe 'on another host' do
      it 'acts like any other simulated request' do
        post '/expect', @body, :host => 'foo.fake.local'
        response.body.should == "Simulator received mismatched request\n"
      end
    end
  end

  %w(GET POST PUT DELETE HEAD).each do |verb|
    describe "receiving an arbitrary #{verb} on a faked host" do
      before do
        Fakettp::Simulator.stub! :record_error
      end

      define_method :do_request do
        send verb.downcase.to_sym, '/foo/bar'
      end

      it 'simulates handling the request' do
        Fakettp::Simulator.should_receive(:handle_request).with(
            an_instance_of(Binding)).and_return ' '
        do_request
      end

      describe 'when the simulator returns an error' do
        before do
          @error = Fakettp::Expectation::Error.new('foo')
          Fakettp::Simulator.stub!(:handle_request).and_raise @error
        end

        it 'returns a 500 status' do
          do_request
          @response.status.should == 500
        end

        it 'returns a plain text response' do
          do_request
          @response.content_type.should == 'text/plain'
        end

        unless verb == 'HEAD' # No body for that one
          it 'returns an error message' do
            do_request
            @response.body.should == "Simulator received mismatched request\n"
          end
        end
      end
    end
  end

  describe 'getting /verify' do
    before do
      Fakettp::Simulator.stub! :verify
      @errors = 'bar'
      Fakettp::Simulator.stub!(:list_errors).and_return @errors
    end

    describe 'on the fakettp host' do
      def do_get
        get '/verify', nil, :host => @host
      end

      it 'verifies the simulator' do
        Fakettp::Simulator.should_receive :verify
        do_get
      end

      it 'returns a plain text response' do
        do_get
        @response.content_type.should == 'text/plain'
      end

      describe 'when verification succeeds' do
        before do
          Fakettp::Simulator.stub!(:verify).and_return true
        end

        it 'is successful' do
          do_get
          @response.should be_ok
        end

        it 'returns an acknowledgement message' do
          do_get
          @response.body.should == "Verify OK\n"
        end
      end

      describe 'when verification fails' do
        before do
          Fakettp::Simulator.stub!(:verify).and_return false
        end

        it 'returns 500 Internal Error' do
          do_get
          @response.status.should == 500
        end

        it 'lists the errors' do
          do_get
          @response.body.should == @errors
        end
      end
    end
    
    describe 'on another host' do
      it 'acts like any other simulated request' do
        get '/verify', nil, :host => 'foo.fake.local'
        response.body.should == "Simulator received mismatched request\n"
      end
    end
  end

  describe 'getting /' do
    describe 'on the fakettp host' do
      before do
        expectation_1 = stub :expectation, :id => 1, :render => 'foo'
        expectation_2 = stub :expectation, :id => 2, :render => 'bar'
        Fakettp::Expectation.stub!(:all).and_return [expectation_1, expectation_2]
      end
      
      def do_get
        get '/', nil, :host => @host
        @response_doc = Hpricot(@response.body)
      end

      it 'returns an html response' do
        do_get
        response.content_type.should == 'text/html'
      end
      
      it 'sets the title' do
        do_get
        (@response_doc/'head/title').inner_html.should == 'FakeTTP'
      end
      
      it 'renders a div for each expectation' do
        do_get
        @response_doc.search("//div[@class='expectation']").size.should == 2
      end
      
      it 'numbers the expectations' do
        do_get
        (@response_doc/"//h1[1]").inner_html.should == '1'
        (@response_doc/"//h1[2]").inner_html.should == '2'
      end
      
      it 'displays the expectation contents' do
        do_get
        (@response_doc/"//div[@class='expectation'][1]/pre").inner_html.should == 'foo'
        (@response_doc/"//div[@class='expectation'][2]/pre").inner_html.should == 'bar'
      end
    end
    
    describe 'on another host' do
      it 'acts like any other simulated request' do
        get '/', nil, :host => 'foo.fake.local'
        response.body.should == "Simulator received mismatched request\n"
      end
    end
  end
end

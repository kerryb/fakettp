require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'nokogiri'

describe 'Controller' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

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
        post '/reset', nil, 'HTTP_HOST' => @host
      end

      it 'resets the simulator' do
        Fakettp::Simulator.should_receive :reset
        do_post
      end

      it 'is successful' do
        do_post
        last_response.should be_ok
      end

      it 'returns a plain text response' do
        do_post
        last_response.content_type.should == 'text/plain'
      end

      it 'returns an acknowledgement message' do
        do_post
        last_response.body.should == "Reset OK\n"
      end
    end

    describe 'on another host' do
      it 'acts like any other simulated request' do
        post '/reset', nil, 'HTTP_HOST' => 'foo.fake.local'
        last_response.body.should == "Simulator received mismatched request\n"
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
        post '/expect', @body, 'HTTP_HOST' => @host
      end

      it 'sets a simulator expectation using the request body' do
        Fakettp::Simulator.should_receive(:<<).with @body
        do_post
      end

      it 'is successful' do
        do_post
        last_response.should be_ok
      end

      it 'returns a plain text response' do
        do_post
        last_response.content_type.should == 'text/plain'
      end

      it 'returns an acknowledgement message' do
        do_post
        last_response.body.should == "Expect OK\n"
      end
    end

    describe 'on another host' do
      it 'acts like any other simulated request' do
        post '/expect', @body, 'HTTP_HOST' => 'foo.fake.local'
        last_response.body.should == "Simulator received mismatched request\n"
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
          last_response.status.should == 500
        end

        it 'returns a plain text response' do
          do_request
          last_response.content_type.should == 'text/plain'
        end

        unless verb == 'HEAD' # No body for that one
          it 'returns an error message' do
            do_request
            last_response.body.should == "Simulator received mismatched request\n"
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
        get '/verify', nil, 'HTTP_HOST' => @host
      end

      it 'verifies the simulator' do
        Fakettp::Simulator.should_receive :verify
        do_get
      end

      it 'returns a plain text response' do
        do_get
        last_response.content_type.should == 'text/plain'
      end

      describe 'when verification succeeds' do
        before do
          Fakettp::Simulator.stub!(:verify).and_return true
        end

        it 'is successful' do
          do_get
          last_response.should be_ok
        end

        it 'returns an acknowledgement message' do
          do_get
          last_response.body.should == "Verify OK\n"
        end
      end

      describe 'when verification fails' do
        before do
          Fakettp::Simulator.stub!(:verify).and_return false
        end

        it 'returns 500 Internal Error' do
          do_get
          last_response.status.should == 500
        end

        it 'lists the errors' do
          do_get
          last_response.body.should == @errors
        end
      end
    end

    describe 'on another host' do
      it 'acts like any other simulated request' do
        get '/verify', nil, 'HTTP_HOST' => 'foo.fake.local'
        last_response.body.should == "Simulator received mismatched request\n"
      end
    end
  end

  describe 'getting /' do
    describe 'on the fakettp host' do
      before do
        expectation_1 = stub :expectation, :id => 1, :status => 'pass', :contents => 'foo'
        expectation_2 = stub :expectation, :id => 2, :status => 'fail', :contents => 'bar'
        expectation_3 = stub :expectation, :id => 3, :status => 'pending', :contents => 'baz'
        Fakettp::Expectation.stub!(:all).and_return [expectation_1, expectation_2, expectation_3]
      end

      def do_get
        get '/', nil, 'HTTP_HOST' => @host
        @response_doc = Nokogiri::XML(last_response.body)
      end

      it 'returns an html response' do
        do_get
        last_response.content_type.should == 'text/html'
      end

      it 'sets the title' do
        do_get
        (@response_doc/'head/title').inner_html.should == 'FakeTTP'
      end

      it 'renders a div for each expectation' do
        do_get
        @response_doc.search("//div[@class='expectation']").size.should == 3
      end

      it 'numbers the expectations' do
        do_get
        (@response_doc/"//div/h1").map(&:inner_html).should == %w(1 2 3)
      end

      it 'displays the expectation contents' do
        do_get
        (@response_doc/"//div[@class='expectation']/pre").map(&:inner_html).should == %w(foo bar baz)
      end

      describe 'for passed expectations' do
        it "sets the request div class to 'request pass'" do
          do_get
          (@response_doc/"//body/div[1]/@class").to_s.should == 'request pass'
        end
      end

      describe 'for failed expectations' do
        it "sets the request div class to 'request fail'" do
          do_get
          (@response_doc/"//body/div[2]/@class").to_s.should == 'request fail'
        end
      end

      describe 'for pending expectations' do
        it "sets the request div class to 'request pending'" do
          do_get
          (@response_doc/"//body/div[3]/@class").to_s.should == 'request pending'
        end
      end
    end

    describe 'on another host' do
      it 'acts like any other simulated request' do
        get '/', nil, 'HTTP_HOST' => 'foo.fake.local'
        last_response.body.should == "Simulator received mismatched request\n"
      end
    end
  end
end

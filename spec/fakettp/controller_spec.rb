require File.dirname(__FILE__) + '/../spec_helper'

describe 'Controller' do
  include Sinatra::Test
  
  describe 'posting to /reset' do
    before do
      Fakettp::Simulator.stub! :reset
    end

    def do_post
      post '/reset'
    end

    it 'should reset the simulator' do
      Fakettp::Simulator.should_receive :reset
      do_post
    end

    it 'should be successful' do
      do_post
      @response.should be_ok
    end

    it 'should return a plain text response' do
      do_post
      @response.content_type.should == 'text/plain'
    end

    it 'should return an acknowledgement message' do
      do_post
      @response.body.should == "Reset OK\n"
    end
  end

  describe 'posting an expectation to /expect' do
    before do
      @body = 'foo'
      Fakettp::Simulator.stub! :<<
    end

    def do_post
      post '/expect', @body
    end

    it 'should set a simulator expectation using the request body' do
      Fakettp::Simulator.should_receive(:<<).with @body
      do_post
    end

    it 'should be successful' do
      do_post
      @response.should be_ok
    end

    it 'should return a plain text response' do
      do_post
      @response.content_type.should == 'text/plain'
    end

    it 'should return an acknowledgement message' do
      do_post
      @response.body.should == "Expect OK\n"
    end
  end

  %w(GET POST PUT DELETE HEAD).each do |verb|
    describe "receiving an arbitrary #{verb}" do
      before do
        Fakettp::Simulator.stub! :record_error
      end

      define_method :do_request do
        send verb.downcase.to_sym, '/foo/bar'
      end

      it 'should simulate handling the request' do
        Fakettp::Simulator.should_receive(:handle_request).with(
            an_instance_of(Sinatra::Request), an_instance_of(Sinatra::Response)
          ).and_return ' '
        do_request
      end

      describe 'when the simulator returns an error' do
        before do
          @error = Fakettp::Expectation::Error.new('foo')
          Fakettp::Simulator.stub!(:handle_request).and_raise @error
        end

        it 'should return a 500 status' do
          do_request
          @response.status.should == 500
        end

        it 'should return a plain text response' do
          do_request
          @response.content_type.should == 'text/plain'
        end

        unless verb == 'HEAD' # No body for that one
          it 'should return an error message' do
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

    def do_get
      get '/verify'
    end

    it 'should verify the simulator' do
      Fakettp::Simulator.should_receive :verify
      do_get
    end

    it 'should return a plain text response' do
      do_get
      @response.content_type.should == 'text/plain'
    end

    describe 'when verification succeeds' do
      before do
        Fakettp::Simulator.stub!(:verify).and_return true
      end

      it 'should be successful' do
        do_get
        @response.should be_ok
      end

      it 'should return an acknowledgement message' do
        do_get
        @response.body.should == "Verify OK\n"
      end
    end

    describe 'when verification fails' do
      before do
        Fakettp::Simulator.stub!(:verify).and_return false
      end

      it 'should return 500 Internal Error' do
        do_get
        @response.status.should == 500
      end

      it 'should list the errors' do
        do_get
        @response.body.should == @errors
      end
    end
  end
end

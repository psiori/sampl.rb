require 'minitest/autorun'
require 'sampl'

describe Sampl do
  before do
  end
  
  describe "endpoint" do
    
    it "must not be nil" do
      Sampl.endpoint.wont_be_nil()
    end
    
    it "must return a string" do
      Sampl.endpoint.must_be_kind_of String
    end
    
    it "must have a default value that connects to psiori" do
      Sampl.endpoint.must_equal "https://events.neurometry.com/sample/v01/event" 
    end
    
    it "must remember a set value" do
      value = Sampl.endpoint
      Sampl.endpoint "test"
      Sampl.endpoint.must_equal "test"
      Sampl.endpoint value
      Sampl.endpoint.must_equal value
    end
    
  end
  
  describe "version" do
    
    it "must return a version string" do
      Sampl.version.wont_be_nil
      Sampl.version.must_be_kind_of String
      Sampl.version.must_match /.+\..+\..+/
    end
    
    it "must return value larger or equal to 0.0.3" do
      # update this if you increase version numbers. should at least
      # match the last released version so it's sure no stepping back
      # my occur
      tmajor = 0;
      tminor = 0;
      tbuild = 3;
      
      major, minor, build = Sampl.version.split('.').map { |v| v.to_i }
      
      major.must_be :>=, tmajor
      if major == tmajor
        minor.must_be :>=, tminor
        if minor == tminor
          build.must_be :>=, tbuild
        end
      end      
    end
    
    it "must match the interal version string" do
      Sampl.version.must_equal Sampl::VERSION
    end
    
  end
  
  describe "server_side" do
    
    it "must return true on default" do
      Sampl.server_side.must_equal true
    end
    
    it "should store the value set by the user" do
      value = Sampl.server_side
      Sampl.server_side !value
      Sampl.server_side.must_equal !value
      Sampl.server_side value
      Sampl.server_side.must_equal value
    end
    
  end
  
  describe "app_token" do
  
    it "must be empty on default" do
      assert_equal (Sampl.app_token.nil? || Sampl.app_token.empty?), true
    end
  
    it "should store the value set by the user" do
      value = Sampl.app_token
      Sampl.app_token "my-token"
      Sampl.app_token.must_equal "my-token"
      Sampl.app_token value.nil? ? "" : value
      Sampl.app_token.must_equal value.nil? ? "" : value
    end
  
  end
  
  describe "default_arguments" do
    
    it "must always return a hash when asked" do
      Sampl::Basement.default_arguments.must_be_kind_of Hash
    end
    
    it "must have mandatory values set by default" do
      Sampl::Basement.default_arguments[:sdk].must_equal "Sampl.rb"
      Sampl::Basement.default_arguments[:sdk_version].must_equal Sampl.version
      Sampl::Basement.default_arguments[:event_category].must_equal "custom"
      Sampl::Basement.default_arguments[:server_side].must_equal true
    end
    
  end
  
  describe "track" do
    
    it "must receive :created when sending valid event to psiori" do
      response = Sampl.track('sample.rb_test_event', 'test', { app_token: 'sample.rb-test-token', debug: true })
      response.wont_be_nil
      response.code.must_be :==, 201
    end
    
    it "must receive :bad_request when mandatory argument is missing" do
      response = Sampl.track('sample.rb_test_event', 'test', { debug: true })
      response.wont_be_nil
      response.code.must_be :==, 400
    end
    
  end
end
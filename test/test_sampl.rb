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
end
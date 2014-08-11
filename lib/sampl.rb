require 'httparty'

require 'sampl/version'

module Sampl

  def self.included(base)
    base.extend ClassMethods
    base.send :include, HTTParty::ModuleInheritableAttributes
    base.send(:mattr_inheritable, :default_arguments)
    base.send(:mattr_inheritable, :endpoint)
    base.instance_variable_set("@default_arguments", {})
    base.instance_variable_set("@endpoint", "http://events.neurometry.com/sample/v01/event")
  end  
  
  module ClassMethods
    
    def version
      Sampl::VERSION
    end
    
    def app_token(app_token)
      default_arguments[:app_token] = app_token
    end

    def track(event_name, event_category="custom", arguments={}, &block)
      perform_tracking event_name, event_category, arguments, &block
    end
    
    def default_arguments #:nodoc:
      @default_arguments
    end
    
    def endpoint
      @endpoint
    end 
    
    private
    
      def perform_tracking(event_name, event_category, arguments, &block)
        
        arguments = Util.hash_deep_dup(default_arguments).merge(arguments).merge({
          event_name: event_name,
          event_category: event_category
        })
        
        HTTParty.post(endpoint, 
                      body: { p: arguments }, 
                      headers: { 'Accept' => 'application/json'}, 
                      &block)
      end
    
  end
  
  
  class Basement    #:nodoc:
    include Sampl   # because of the included-method this will pull the ClassMethods into Basement.
  end
  
  def self.track(*args, &block)
    Basement.track(*args, &block)
  end

  def self.version(*args, &block)
    Basement.version(*args, &block)
  end
  
end
require 'httparty'

require 'sampl/version'
require 'sampl/util'

module Sampl

  def self.included(base)
    base.extend ClassMethods
    base.send :include, Sampl::Util
    base.instance_variable_set("@default_arguments", {})
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
    
    private
    
      def perform_tracking(event_name, event_category, arguments, &block)
        
        arguments = Util.hash_deep_dup(default_arguments).merge(arguments).merge({
          event_name: event_name,
          event_category: event_category
        })
        
        HTTParty.post('http://events.neurometry.com/sample/v01/event', 
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
require 'httparty'

require 'sampl/version'

module Sampl

  def self.included(base)
    base.extend ClassMethods
    # the following inheritance pattern was explained in this block post by John Nunemaker:
    # http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
    # We borrow its implementation from HTTParty so usage is as close to HTTParty as possible.
    base.send :include, HTTParty::ModuleInheritableAttributes
    base.send(:mattr_inheritable, :default_arguments)
    base.send(:mattr_inheritable, :endpoint)
    base.instance_variable_set("@default_arguments", {
      sdk:         "Sampl.rb",
      sdk_version: Sampl::VERSION,
    })
    base.instance_variable_set("@endpoint", "http://events.neurometry.com/sample/v01/event")
  end  
  
  module ClassMethods
    
    def version
      Sampl::VERSION
    end
    
    def default_arguments #:nodoc:
      @default_arguments
    end
    
    def endpoint
      @endpoint
    end 
    
    def endpoint=(newEndpoint)
      @endpoint = newEndpoint
    end
    
    def app_token=(new_app_token)
      default_arguments[:app_token] = new_app_token
    end
    
    def app_token
      default_arguments[:app_token]
    end
    
    def track(event_name, event_category="custom", arguments={}, &block)
      perform_tracking event_name, event_category, arguments, &block
    end
    
    private
    
      def perform_tracking(event_name, event_category, arguments, &block) # :nodoc:
        # this is the central method that actually performs the tracking call
        # with the help of HTTParty.
  
        arguments = HTTParty::ModuleInheritableAttributes.hash_deep_dup(default_arguments).merge(arguments).merge({
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
  
  def self.endpoint
    Basement.endpoint
  end

  # change the URI where to send the events. Please note this
  # that chaging this on the static inteface of Sampl directly
  # (Sampl.endpoint="http://my.url.com") will affect the whole
  # app and all tracking calls to Sampl. Thus, all workers
  # in a Rails app will send events to the same endpoint when
  # working with the static interface. Use custom classes
  # when in need for different endpoints per worker / request.
  def self.endpoint=(new_endpoint)
    Basement.endpoint = new_endpoint
  end
  
  def self.track(*args, &block)
    Basement.track(*args, &block)
  end

  def self.version(*args, &block)
    Basement.version(*args, &block)
  end
  
end
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
    base.send(:mattr_inheritable, :default_endpoint)
    base.instance_variable_set("@default_arguments", {
      sdk:            "Sampl.rb",
      sdk_version:    Sampl::VERSION,
      event_category: "custom",
      server_side:    true
    })
    base.instance_variable_set("@default_endpoint", "http://events.neurometry.com/sample/v01/event")
  end  
  
  module ClassMethods
    
    def version
      Sampl::VERSION
    end
    
    def default_arguments #:nodoc:
      @default_arguments
    end

    def endpoint(endpoint=nil)
      if endpoint.nil?
        @default_endpoint
      else
        @default_endpoint = endpoint
      end
    end
    
    def app_token(app_token=nil)
      if app_token.nil?
        default_arguments[:app_token]  
      else
        default_arguments[:app_token] = app_token
      end
    end
    
    def server_side(flag=nil)
      if flag.nil?
        default_arguments[:server_side]  
      else
        default_arguments[:server_side] = flag
      end
    end
        
    def track(event_name, event_category="custom", arguments={}, &block)
      perform_tracking event_name, event_category, arguments, &block
    end
    
    private
    
      def my_blank?(value)
        value.nil? || (value.respond_to?(:empty?) ? !!value.empty? : false)
      end
    
      def perform_tracking(event_name, event_category, arguments, &block) # :nodoc:
        # this is the central method that actually performs the tracking call
        # with the help of HTTParty.
        
        arguments = arguments.merge({
          event_name: event_name,
          event_category: event_category # will overwrite default value, iff provided and not blank?
        }).select { |key, value| !my_blank?(value) }
  
        arguments = HTTParty::ModuleInheritableAttributes.hash_deep_dup(default_arguments).merge({
          timestamp: DateTime.now        # will be overwritten by (optional) user-provided timestamp
        }).merge(arguments)
        
        HTTParty.post(endpoint, 
                      body: { p: arguments }, 
                      headers: { 'Accept' => 'application/json'}, 
                      &block)
      end
    
  end
  
  
  class Basement    #:nodoc:
    include Sampl   # because of the included-method this will pull the ClassMethods into Basement.
  end
  
  # change the URI where to send the events. Please note this
  # that chaging this on the static inteface of Sampl directly
  # (Sampl.endpoint="http://my.url.com") will affect the whole
  # app and all tracking calls to Sampl. Thus, all workers
  # in a Rails app will send events to the same endpoint when
  # working with the static interface. Use custom classes
  # when in need for different endpoints.
  def self.endpoint(endpoint=nil)
    Basement.endpoint(endpoint)
  end
  
  def self.app_token(app_token=nil)
    Basement.app_token(app_token)
  end

  def self.server_side(flag=nil)
    Basement.server_side(flag)
  end
  
  def self.track(*args, &block)
    Basement.track(*args, &block)
  end

  def self.version(*args, &block)
    Basement.version(*args, &block)
  end
  
end
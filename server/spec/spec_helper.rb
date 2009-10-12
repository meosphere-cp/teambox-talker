require 'rubygems'
require 'spec'
$:.unshift File.dirname(__FILE__) + "/../lib"
require "talker"
require "logger"
Dir[File.dirname(__FILE__) + "/mocks/*.rb"].each { |f| require f }

$TALKER_DEBUG = true

# Try installing em-spec from http://github.com/macournoyer/em-spec
# if this doesn't work
require 'em/spec'
require 'em/spec/rspec'
EM.spec_backend = EM::Spec::Rspec

require "moqueue"

# Patch moqueue for some missing methods
module Moqueue
  class MockQueue
    def subscribed?
      !!@subscribe_block
    end
    
    def delete
      # noop
    end

    def reset
      # noop
    end
  end
end

overload_amqp

module Helpers
  TEST_PORT = 61900
  
  def start_server(options={})
    Talker.logger = ::Logger.new(nil)
    @server = Talker::Channel::Server.new({ :port => TEST_PORT }.merge(options))
    @server.authenticator = NullAuthenticator.new
    @server.start
    
    @presence = Talker::Presence::Server.new(NullPersister.new)
    @presence.start
    
    @server
  end
  
  def stop_server
    @server.stop
  end
  
  def connect(options, &block)
    Talker::Client.connect({ :token => "dummy", :port => TEST_PORT }.merge(options), &block)
  end
end

Spec::Runner.configure do |config|
  config.include Helpers

  config.before do
    Moqueue::MockBroker.instance.reset!
    start_server
  end
  
  config.after do
    stop_server
  end
end
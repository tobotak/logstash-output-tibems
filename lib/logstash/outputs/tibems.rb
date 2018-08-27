# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "stud/interval"
require "socket" # for Socket.gethostname

require "logstash/event"
require "rubygems"
require 'jms-2.0.jar'
require 'tibjms.jar'
require 'tibjmsadmin.jar'
require 'tibcrypt.jar'

# An tibems output that does nothing.
class LogStash::Outputs::Tibems < LogStash::Outputs::Base
  config_name "tibems"

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, "json"

  config :user, :validate => :string, :required => true
  config :password , :validate => :string, :required => true
  config :queueName, :validate => :string, :required => true
  config :initialContextFactory, :validate => :string, :required => true
  config :providerUrl, :validate => :string, :required => true
  config :queueConnectionFactory, :validate => :string, :requierd => true


  def initialize(*args)
    require "java"
    super(*args)
  end # def initialize

  public
  def register
    @logger.info("opening connection to EMS server.", :providerUrl => @providerUrl);
    begin
      @connection = javax.jms.Connection;
      @session = javax.jms.Session;
      @destination = javax.jms.Destination;
      @producer = javax.jms.MessageProducer;
      @msg = javax.jms.TextMessage;

      @logger.debug("========== factory definited")
      @factory = com.tibco.tibjms.TibjmsConnectionFactory.new(@providerUrl);
      @logger.debug("========== factory initialized")
      @logger.debug("========== initailizating connection with:", :user => @user, :password => @password)
      @connection = @factory.createConnection(@user,@password);
      @logger.debug("========== connection created ", @connection)
      @session = @connection.createSession(javax.jms.Session.AUTO_ACKNOWLEDGE);
      @logger.debug("========== session created")
      @destination = @session.createQueue(@queueName);
      @logger.debug("========== queue ref created", :queuename => @destination.getQueueName())
      @producer = @session.createProducer(@destination);
      @logger.debug("========== producer created")
      @connection.start();
      @logger.debug("========== connection ID:", :clientID => @connection.getClientID())
    rescue Exception => e
      @logger.error("Error initalizing output ems", :exception => e, :backtrace => e.backtrace)
      raise
    end
    @logger.info("Connection established");
  end # def register

  public
  def receive(event)
    begin
        @logger.debug("========== Event received")
        @msg = @session.createTextMessage();
        @msg.setText(event.get("message"))
        @producer.send(@msg)
        @logger.info(("========== Sent message to ems", :message_timestamp => event.get("timestamp"))
        @logger.debug(("========== ", :message => event.get("message"))
    rescue => e
        @logger.warn("Failed to send event to JMS", :event => event, :exception => e, :backtrace => e.backtrace)
        raise
    end
    return "Event received"
  end # def event
end # class LogStash::Outputs::Tibems

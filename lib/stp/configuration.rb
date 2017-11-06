module Stp
  class Configuration
    LEVEL_DEBUG = Logger::DEBUG
    LEVEL_INFO  = Logger::INFO
    LEVEL_WARN  = Logger::WARN
    LEVEL_ERROR = Logger::ERROR
    LEVEL_FATAL = Logger::FATAL

    SOAP_LOG_LEVELS = [:debug, :info, :warn, :error, :fatal]

    attr_accessor :wsdl, :key_path, :key_passphrase, :log_level, :authorized_ip

    def initialize
      @wsdl =
        'http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL'
      @key_passphrase = ''
      @log_level = ENV['STP_LOG'].nil? ?
        LEVEL_INFO : self.class.const_get("LEVEL_#{ENV['STP_LOG']}")
    end

    def soap_log_level
      SOAP_LOG_LEVELS[@log_level]
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end

  def self.reset
    @configuration = Configuration.new
  end
end

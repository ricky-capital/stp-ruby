module Stp
  class Configuration
    attr_accessor :wsdl, :key_path, :key_passphrase
    # /Users/daniel/Downloads/stp/Ejemplos/PHP/prueba-key.pem
    # 12345678

    def initialize
      @wsdl =
        'http://demo.stpmex.com:7004/speidemo/webservices/SpeiServices?WSDL'
      @key_passphrase = ''
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

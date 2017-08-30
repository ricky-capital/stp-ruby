module Stp
  class Client
    attr_accessor :client

    def initialize
      @client = Savon.client(wsdl: Stp.configuration.wsdl)
    end
  end
end

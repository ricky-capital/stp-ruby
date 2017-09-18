module Stp
  class Error < StandardError
    attr_reader :message, :response

    def initialize(message = nil, response = nil)
      super(message)

      @response = response
    end
  end
end

module LogInterceptor
  @@intercepted_request = ''
  def self.debug(message = nil, &block)
    message = yield if message.nil?

    # save only the first XMLly message
    if message.include? 'xml version'
      @@intercepted_request = message if @@intercepted_request == ''
    end
  end

  def self.info(message = nil, &block)
    message = yield if message.nil?
  end

  def self.get_intercepted_request
    @@intercepted_request
  end

  def self.level=(level); end
end

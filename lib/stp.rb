# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'savon'
require 'active_support/notifications'
require 'active_support/core_ext/array'

# Config
require 'stp/configuration'

# Version
require 'stp/version'

# Errors
require 'stp/error'

# Utils
require 'stp/validation'
require 'stp/clabe'

# Resources
require 'stp/signer'
require 'stp/client'
require 'stp/orden_pago'
require 'stp/abono'
require 'stp/estado'
require 'stp/bank'

# Engine
require 'stp/engine' if defined?(Rails)

module Stp
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = name
        log.level = configuration.log_level
      end
    end

    def instrument(event, payload)
      ActiveSupport::Notifications.instrument(event, payload)
    end

    def subscribe(event, callable = Proc.new)
      ActiveSupport::Notifications.subscribe(event) do |*args|
        callable.call(args.extract_options![:resource])
      end
    end
  end
end

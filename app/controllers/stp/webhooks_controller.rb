module Stp
  class WebhooksController < ActionController::Base
    before_action :authorize!

    def abono
      process_webhook(Stp::Abono)
    end

    def estado
      process_webhook(Stp::Estado)
    end

    private

      def authorize!
        return if Stp.configuration.authorized_ip.nil?

        if !request.remote_ip.match(Stp.configuration.authorized_ip)
          Stp.logger.info "Unauthorized: #{request.remote_ip}"
          head :unauthorized
        end
      end

      def process_webhook(resource_class)
        begin
          @resource = resource_class.new(request.raw_post)

          Stp.instrument(resource_class::EVENT_NAME, resource: @resource)

          render_ok
        rescue Stp::Devolucion => e
          Stp.instrument(Stp::Devolucion::EVENT_NAME, resource: e)

          render_ok
        rescue => e
          render_bad_request
        end
      end

      def render_ok
        head :ok
      end

      def render_bad_request
        head :bad_request
      end
  end
end

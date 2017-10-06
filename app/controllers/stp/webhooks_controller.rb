module Stp
  class WebhooksController < ActionController::Base
    def abono
      process_webhook(Stp::Abono)
    end

    def estado
      process_webhook(Stp::Estado)
    end

    private

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
        render plain: '200 OK'
      end

      def render_bad_request
        render plain: '400 Bad Request', status: :bad_request
      end
  end
end

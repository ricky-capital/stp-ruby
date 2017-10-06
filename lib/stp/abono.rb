module Stp
  class Abono
    EVENT_NAME = 'abono'.freeze

    include Validation

    attr_reader :clave, :fecha_operacion, :institucion_ordenante,
      :institucion_beneficiaria, :clave_rastreo, :monto, :nombre_ordenante,
      :tipo_cuenta_ordenante, :cuenta_ordenante, :rfc_curp_ordenante,
      :nombre_beneficiario, :tipo_cuenta_beneficiario, :cuenta_beneficiario,
      :rfc_curp_beneficiario, :concepto_pago, :referencia_numerica, :empresa,
      :codigo_error

    validates :clave, :monto, :cuenta_beneficiario

    def initialize(xml)
      doc = Nokogiri::XML(xml)

      if doc.xpath('/abono').any?
        parser = Nori.new

        hash = parser.parse(xml)

        hash['abono'].each do |key, value|
          instance_variable_set("@#{key.snakecase}", value)
        end

        @monto = @monto.to_f unless @monto.nil?
      elsif doc.xpath('/devolucion').any?
        @codigo_error = doc.xpath('/devolucion/codigoError').first.text
        @clave = doc.xpath('/devolucion/clave').first.text

        raise Devolucion.new(@codigo_error, @clave, self.class, xml)
      else
        raise Error.new('Malformed XML Error', xml)
      end
    end
  end
end

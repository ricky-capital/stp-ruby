module Stp
  class Abono
    include Validation

    REJECT_REASONS = {
       '1': 'Cuenta inexistente',
       '2': 'Cuenta bloqueada',
       '3': 'Cuenta cancelada',
       '5': 'Cuenta en otra divisa',
       '6': 'Cuenta no pertenece al banco receptor',
      '13': 'Beneficiario no reconoce el pago',
      '14': 'Falta información mandatorio para completar el pago',
      '15': 'Tipo de pago erróneo',
      '16': 'Tipo de operación errónea',
      '17': 'Tipo de cuenta no corresponde',
      '18': 'A solicitud del emisor',
      '19': 'Carácter invalido.',
      '20': 'Excede el límite de saldo autorizado de la cuenta.',
      '21': 'Excede el límite de abonos permitidos en el mes en la cuenta.',
      '22': 'Número de telefonía móvil no registrado.',
      '23': 'Cuenta adicional no recibe pagos que no proceden de Banxico.'
    }

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

        raise Error.new(REJECT_REASONS[@codigo_error], xml)
      else
        raise Error.new('Malformed XML Error', xml)
      end
    end
  end
end

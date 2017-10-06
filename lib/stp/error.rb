module Stp
  class Error < StandardError
    attr_reader :response

    def initialize(message = nil, response = nil)
      super(message)

      @response = response
    end
  end

  class Devolucion < Error
    EVENT_NAME = 'devolucion'

    REJECT_REASONS = {
       '1' => 'Cuenta inexistente',
       '2' => 'Cuenta bloqueada',
       '3' => 'Cuenta cancelada',
       '5' => 'Cuenta en otra divisa',
       '6' => 'Cuenta no pertenece al banco receptor',
      '13' => 'Beneficiario no reconoce el pago',
      '14' => 'Falta información mandatorio para completar el pago',
      '15' => 'Tipo de pago erróneo',
      '16' => 'Tipo de operación errónea',
      '17' => 'Tipo de cuenta no corresponde',
      '18' => 'A solicitud del emisor',
      '19' => 'Carácter invalido.',
      '20' => 'Excede el límite de saldo autorizado de la cuenta.',
      '21' => 'Excede el límite de abonos permitidos en el mes en la cuenta.',
      '22' => 'Número de telefonía móvil no registrado.',
      '23' => 'Cuenta adicional no recibe pagos que no proceden de Banxico.'
    }

    attr_reader :id, :resource_class

    def initialize(codigo_error, id = nil, resource_class = nil, response = nil)
      super(REJECT_REASONS[codigo_error], response)

      @id = id
      @resource_class = resource_class
    end
  end
end

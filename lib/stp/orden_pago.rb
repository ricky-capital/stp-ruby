module Stp
  class OrdenPago
    extend Savon::Model

    include Validation

    client wsdl: Stp.configuration.wsdl

    operations :registra_orden

    attr_accessor :institucion_contraparte, :empresa, :fecha_operacion,
      :folio_origen, :clave_rastreo, :institucion_operante, :monto, :tipo_pago,
      :tipo_cuenta_ordenante, :nombre_ordenante, :cuenta_ordenante,
      :rfc_curp_ordenante, :tipo_cuenta_beneficiario, :nombre_beneficiario,
      :cuenta_beneficiario, :rfc_curp_beneficiario, :email_beneficiario,
      :tipo_cuenta_beneficiario_2, :nombre_beneficiario_2,
      :cuenta_beneficiario_2, :rfc_curp_beneficiario_2, :concepto_pago,
      :concepto_pago_2, :clave_cat_usuario_1, :clave_cat_usuario_2, :clave_pago,
      :referencia_cobranza, :referencia_numerica, :tipo_operacion, :topologia,
      :usuario, :medio_entrega, :prioridad, :iva, :firma

    validates :clave_rastreo, :concepto_pago, :cuenta_beneficiario, :empresa,
      :institucion_contraparte, :institucion_operante, :monto,
      :nombre_beneficiario, :referencia_numerica, :rfc_curp_beneficiario,
      :tipo_cuenta_beneficiario, :tipo_pago

    # causaDevolucion
    # claveCatUsuario1
    # claveCatUsuario2
    # clavePago
    # claveRastreo
    # claveRastreoDevolucion
    # conceptoPago
    # conceptoPago2
    # cuentaBeneficiario
    # cuentaBeneficiario2
    # cuentaOrdenante
    # emailBeneficiario
    # empresa
    # estado
    # facturas
    # fechaOperacion
    # firma
    # folioOrigen
    # idCliente
    # idEF
    # institucion_contraparte
    # institucionOperante
    # iva
    # medioEntrega
    # monto
    # montoInteres
    # montoOriginal
    # nombreBeneficiario
    # nombreBeneficiario2
    # nombreOrdenante
    # prioridad
    # referenciaCobranza
    # referenciaNumerica
    # reintentos
    # rfcCurpBeneficiario
    # rfcCurpBeneficiario2
    # rfcCurpOrdenante
    # tipoCuentaBeneficiario
    # tipoCuentaBeneficiario2
    # tipoCuentaOrdenante
    # tipoOperacion
    # tipoPago
    # topologia
    # tsAcuseBanxico
    # tsAcuseConfirmacion
    # tsCaptura
    # tsConfirmacion
    # tsDevolucion
    # tsDevolucionRecibida
    # tsEntrega
    # tsLiquidacion
    # usuario

    def initialize(params = {})
      @params = params
      params.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def sign
      return false if !valid?

      signer = Signer.new
      @firma = signer.sign(to_s)
    end

    def to_s
      data = <<~HEREDOC
        ||
        #{@institucion_contraparte}|
        #{@empresa}|
        #{@fecha_operacion}|
        #{@folio_origen}|
        #{@clave_rastreo}|
        #{@institucion_operante}|
        #{'%.2f' % @monto}|
        #{@tipo_pago}|
        #{@tipo_cuenta_ordenante}|
        #{@nombre_ordenante}|
        #{@cuenta_ordenante}|
        #{@rfc_curp_ordenante}|
        #{@tipo_cuenta_beneficiario}|
        #{@nombre_beneficiario}|
        #{@cuenta_beneficiario}|
        #{@rfc_curp_beneficiario}|
        #{@email_beneficiario}|
        #{@tipo_cuenta_beneficiario_2}|
        #{@nombre_beneficiario_2}|
        #{@cuenta_beneficiario_2}|
        #{@rfc_curp_beneficiario_2}|
        #{@concepto_pago}|
        #{@concepto_pago_2}|
        #{@clave_cat_usuario_1}|
        #{@clave_cat_usuario_2}|
        #{@clave_pago}|
        #{@referencia_cobranza}|
        #{@referencia_numerica}|
        #{@tipo_operacion}|
        #{@topologia}|
        #{@usuario}|
        #{@medio_entrega}|
        #{@prioridad}|
        #{'%.2f' % @iva}
        ||
      HEREDOC

      data.tr("\n", '')
    end
  end
end

require 'spec_helper'
require 'support/signer_helpers'
require 'support/log_interceptor'
require 'savon/mock/spec_helper'

RSpec.describe Stp::OrdenPago do
  include SignerHelpers
  include Savon::SpecHelper

  def build_order
    configure_signer

    Stp::OrdenPago.new(
      empresa: 'pruebas',
      clave_rastreo: 'IACH0OEE80002',
      concepto_pago: 'SWI SPEI Payment Ñ á é',
      cuenta_beneficiario: '110180077000000018',
      cuenta_ordenante: '846180000050000011',
      referencia_numerica: 2,
      monto: 4600000.82,
      tipo_cuenta_beneficiario: 40,
      tipo_pago: 1,
      institucion_contraparte: 90633,
      nombre_beneficiario: 'alfredo',
      institucion_operante: 46,
      iva: 16,
      rfc_curp_beneficiario: 'RFCBEN'
    )
  end

  after :each do
    Stp.reset
  end

  context 'when given incomplete attributes' do
    it 'is not valid' do
      order = Stp::OrdenPago.new()

      expect(order.valid?).to be false
    end
  end

  context 'when given valid attributes' do
    it 'is valid' do
      order = build_order

      expect(order.valid?).to be true
    end

    it 'generates the signature correctly' do
      order = build_order

      order.send(:sign)

      expect(order.firma).to eq(
        'hHs87KUKWyYOD/MYPHinBa2UXTAc3zxXoTu6zouzlWpKY24N/OZty5rpVeCOaihiFmrrL8f5Adx5CY60y3GPHtObPCXq7pAX+NKtKee8oq1ndKrGjDhTVeT0yOtFLkpMB7CZ+gUmczwQsW2JaIA9V6cFPr14tqczDd9/WIZarPE='
      )
    end

    it 'generates the xml correctly' do
      order = build_order

      order.class.send(:global, :logger, LogInterceptor)

      request = File.read('spec/fixtures/orden_pago_request.xml')

      # TODO: this is slow because it calls the SOAP service
      begin
        order.call
      rescue
      end

      expect(LogInterceptor.get_intercepted_request).to eq request
    end

    it 'gets a response' do
      savon.mock!

      order = build_order
      order.send(:sign)

      response = File.read('spec/fixtures/orden_pago_response.xml')

      savon.expects(:registra_orden).with(message: order.to_message)
        .returns(response)

      expect(order.call.to_xml).to eq response

      savon.unmock!
    end
  end
end

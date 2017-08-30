require 'spec_helper'
require 'support/signer_helpers'

RSpec.configure do |c|
  c.include SignerHelpers
end

RSpec.describe Stp::OrdenPago do
  context 'when given incomplete attributes' do
    it 'is not valid' do
      order = Stp::OrdenPago.new()

      expect(order.valid?).to be false
    end
  end

  context 'when given valid attributes' do
    it 'generates the signature correctly' do
      configure_signer

      order = Stp::OrdenPago.new(
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

      order.sign

      expect(order.firma).to eq(
        'hHs87KUKWyYOD/MYPHinBa2UXTAc3zxXoTu6zouzlWpKY24N/OZty5rpVeCOaihiFmrrL8f5Adx5CY60y3GPHtObPCXq7pAX+NKtKee8oq1ndKrGjDhTVeT0yOtFLkpMB7CZ+gUmczwQsW2JaIA9V6cFPr14tqczDd9/WIZarPE='
      )
    end
  end

  after :each do
    Stp.reset
  end
end

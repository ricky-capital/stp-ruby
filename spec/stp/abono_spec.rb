require 'spec_helper'
require 'support/signer_helpers'
require 'support/log_interceptor'
require 'savon/mock/spec_helper'

RSpec.describe Stp::Abono do
  def build_payment
    Stp::Abono.new(File.read('spec/fixtures/send_abono.xml'))
  end

  context 'when payment is successful' do
    it 'is valid' do
      payment = build_payment

      expect(payment.valid?).to be true
    end
  end

  context 'when payment failed' do
    it 'raises an exception' do
      expect {
        Stp::Abono.new(File.read('spec/fixtures/send_abono_error.xml'))
      }.to raise_error(Stp::Devolucion, Stp::Devolucion::REJECT_REASONS['18'])
    end

    it 'captures the payment info' do
      begin
        Stp::Abono.new(File.read('spec/fixtures/send_abono_error.xml'))
      rescue Stp::Devolucion => e
        expect(e.id).to eq '3000'
        expect(e.resource_class).to eq Stp::Abono
      end
    end
  end
end

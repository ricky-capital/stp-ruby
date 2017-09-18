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
      }.to raise_error(Stp::Error, Stp::Abono::REJECT_REASONS['18'])
    end
  end
end

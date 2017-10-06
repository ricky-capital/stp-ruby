require 'spec_helper'
require 'support/signer_helpers'
require 'support/log_interceptor'
require 'savon/mock/spec_helper'

RSpec.describe Stp::Abono do
  def build_status_update
    Stp::Estado.new(File.read('spec/fixtures/estado.xml'))
  end

  context 'when order is successful' do
    it 'is valid' do
      status = build_status_update

      expect(status.valid?).to be true
    end

    it 'is successful' do
      status = build_status_update

      expect(status.success?).to be true
    end
  end

  context 'when order failed' do
    it 'raises an exception' do
      expect {
        Stp::Estado.new(File.read('spec/fixtures/estado_error.xml'))
      }.to raise_error(Stp::Devolucion, Stp::Devolucion::REJECT_REASONS['18'])
    end

    it 'captures the transaction info' do
      begin
        Stp::Estado.new(File.read('spec/fixtures/estado_error.xml'))
      rescue Stp::Devolucion => e
        expect(e.id).to eq '3668949'
        expect(e.resource_class).to eq Stp::Estado
      end
    end
  end
end

require 'rails_helper'
require 'spec_helper'

RSpec.describe Stp::WebhooksController, type: :controller do
  routes { Stp::Engine.routes }

  before(:all) do
    @abonos = []
    @estados = []
    @devoluciones = []

    Stp.subscribe('abono') do |abono|
      @abonos << abono
    end

    Stp.subscribe('estado') do |estado|
      @estados << estado
    end

    Stp.subscribe('devolucion') do |devolucion|
      @devoluciones << devolucion
    end
  end

  context 'when given a successful abono' do
    it 'notifies abono subscribers with an Abono object' do
      post_abono

      expect_successful_abono
    end
  end

  context 'when given a successful estado update' do
    it 'notifies estados subscribers with an Estado object' do
      post :estado, body: File.read('spec/fixtures/estado.xml')

      expect(response.code).to eq '200'
      expect(@estados.last).to be_a(Stp::Estado)
    end
  end

  context 'when given a declined abono' do
    it 'notifies devolucion subscribers with a devolucion abono object' do
      post :abono, body: File.read('spec/fixtures/send_abono_error.xml')

      expect(response.code).to eq '200'
      expect(@devoluciones.last).to be_a(Stp::Devolucion)
      expect(@devoluciones.last.resource_class).to eq(Stp::Abono)
    end
  end

  context 'when given a declined estado' do
    it 'notifies devolucion subscribers with a devolucion estado object' do
      post :estado, body: File.read('spec/fixtures/estado_error.xml')

      expect(response.code).to eq '200'
      expect(@devoluciones.last).to be_a(Stp::Devolucion)
      expect(@devoluciones.last.resource_class).to eq(Stp::Estado)
    end
  end

  context 'when given an incorrect xml' do
    it 'responds with a 400 Bad Request code and no subscriber is notified' do
      clear_all

      post :abono, body: File.read('spec/fixtures/estado.xml')

      expect(response.code).to eq '400'
      expect_all_to_be_empty
    end
  end

  context 'when configured with an authorized IP' do
    it 'responds with unauthorized status when the IP does not match' do
      clear_all

      Stp.configure do |config|
        config.authorized_ip = '1.1.1.1'
      end

      post_abono

      expect(response.code).to eq '401'
      expect_all_to_be_empty
    end

    it 'succeeds if the IP matches' do
      clear_all

      Stp.configure do |config|
        config.authorized_ip = '0.0.0.0'
      end

      post_abono

      expect_successful_abono
    end
  end

  private

    def post_abono
      post :abono, body: File.read('spec/fixtures/send_abono.xml')
    end

    def clear_all
      @abonos.clear
      @estados.clear
      @devoluciones.clear
    end

    def expect_all_to_be_empty
      expect(@abonos).to be_empty
      expect(@estados).to be_empty
      expect(@devoluciones).to be_empty
    end

    def expect_successful_abono
      expect(response.code).to eq '200'
      expect(@abonos.last).to be_a(Stp::Abono)
    end
end

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
      post :abono, body: File.read('spec/fixtures/send_abono.xml')

      expect(response.code).to eq '200'
      expect(@abonos.last).to be_a(Stp::Abono)
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
      @abonos.clear
      @estados.clear
      @devoluciones.clear

      post :abono, body: File.read('spec/fixtures/estado.xml')

      expect(response.code).to eq '400'
      expect(@abonos).to be_empty
      expect(@estados).to be_empty
      expect(@devoluciones).to be_empty
    end
  end
end

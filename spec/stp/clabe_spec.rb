# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stp::Clabe do
  context 'when CLABE is invalid' do
    it 'raises an exception' do
      expect {
        Stp::Clabe.new('032180000118').clabe
      }.to raise_error(Stp::Error, 'CLABE inválida')

      expect {
        Stp::Clabe.new('032180000118359aa').clabe
      }.to raise_error(Stp::Error, 'CLABE inválida')
    end
  end

  context 'when CLABE is valid' do
    it 'calculates verification digit' do
      expect(Stp::Clabe.new('03218000011835971').clabe).to(
        eq '032180000118359719'
      )

      expect(Stp::Clabe.new('00218003224094670').clabe).to(
        eq '002180032240946700'
      )
    end

    it 'gets bank' do
      expect(Stp::Clabe.new('00218003224094670').bank).to eq 'BANAMEX'
    end

    it 'gets bank code' do
      expect(Stp::Clabe.new('00218003224094670').bank_code).to eq '40002'
    end
  end
end

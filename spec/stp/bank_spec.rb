# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stp::Bank do
  context 'when given a valid bank code from a CLABE' do
    it 'returns bank info' do
      expect(Stp::Bank.from_code('002')).to eq ['40002', 'BANAMEX']
    end
  end

  context 'when given an invalid bank code from a CLABE' do
    it 'returns nil' do
      expect(Stp::Bank.from_code('999')).to be_nil
    end
  end
end

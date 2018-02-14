# frozen_string_literal: true

module Stp
  class Clabe
    attr_reader :clabe

    def initialize(key)
      raise Stp::Error, 'CLABE inválida' unless valid?(key)

      @clabe = key
      @clabe = clabe + verification_digit
    end

    def bank
      bank_info.last
    end

    def bank_code
      bank_info.first
    end

    private

    def valid?(key)
      key.chars.length == 17 &&
        key.chars.all? { |x| true if Integer(x) rescue false }
    end

    def verification_digit
      weigth_factors = ([3, 7, 1] * 6)
      weigth_factors.pop

      sum = weigth_factors.zip(@clabe.chars.map(&:to_i))
                          .map { |weight, digit| (weight * digit) % 10 }
                          .inject(:+) % 10

      ((10 - sum) % 10).to_s
    end

    def bank_info
      bank_info = Bank.from_code(@clabe[0..2])

      raise Stp::Error, 'Código de banco inválido' if bank_info.nil?

      bank_info
    end
  end
end

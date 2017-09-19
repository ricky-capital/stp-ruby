module Stp
  class Estado
    include Validation

    attr_reader :id, :empresa, :folio_origen, :estado, :causa_devolucion

    validates :id, :estado

    def initialize(xml)
      doc = Nokogiri::XML(xml)

      if doc.xpath('/estado').any?
        parser = Nori.new

        hash = parser.parse(xml)

        hash['estado'].each do |key, value|
          instance_variable_set("@#{key.snakecase}", value)
        end

        raise Devolucion.new(@causa_devolucion, xml) unless success?
      else
        raise Error.new('Malformed XML Error', xml)
      end
    end

    def success?
      @estado == 'Éxito'
    end
  end
end

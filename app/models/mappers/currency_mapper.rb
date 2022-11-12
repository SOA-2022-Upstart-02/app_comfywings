# frozen_string_literal: false


module ComfyWings
  module Amadeus
    # Data Mapper: Amadeus currencies
    class CurrencyMapper
      def initialize(key, secret, gateway_class = ComfyWings::Amadeus::Api)
        @key = key
        @secret = secret
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key, @secret)
      end

      def search(from, to, from_date, to_date)
        data = @gateway.data_dictionaries(from, to, from_date, to_date)
        CurrencyMapper.build_entity(data)
      end

      def self.build_entity(data)
        CurrencyDataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class CurrencyDataMapper
        def initialize(data)
          @data = data.to_a
        end

        def build_entity
          ComfyWings::Entity::Currency.new(
            id: nil,
            code:,
            name:
          )
        end

        def code
          codes = @data[0].first.to_s
          codes
        end

        def name
          names = @data[0].last.to_s
          names
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require_relative 'auth_token'

# airport token
NEW_TOKEN = AuthToken.new
DEPATURE = 'TPE'

module ComfyWings
  # obtains data from the amadeus api
  class AirportMapper
    def initialize(api_key, api_secret, gateway_class = Amadeus::Api)
      @api_key = api_key
      @api_secret = api_secret
      @gateway_class = gateway_class
      @gateway = @gateway_class.new(@api_key, @api_secret)
    end

    def airport_size(departure)
      @gateway.airport_size(departure)
    end

    def airport_data(departure)
      @gateway.airport_data(departure)
    end

    def self.build_entity(data)
      DataMapper.new(data).build_entity
    end

    # obtain aiport infomation from hash
    class DataMapper
      def initialize(hash_data)
        @data = hash_data
      end

      def build_entity
        Entity::Airport.new(
          city_name:,
          iata_code:
        )
      end

      def iata_code
        @data['iataCode']
      end

      def city_name
        @data['name']
      end
    end
  end
end


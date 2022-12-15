# frozen_string_literal: true

require 'dry/transaction'
require 'digest'

module ComfyWings
  module Service
    # Retrieves array of all currencies
    class RetrieveAirport
      include Dry::Transaction

      step :retrieve_airport
      step :reify_airport

      private

      DB_ERR = 'We encountered an issue accessing the database.'

      def retrieve_airport(iata_code)
        result = Gateway::Api.new(ComfyWings::App.config).get_airport(iata_code)
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get airport')
      end

      def reify_airport(airport_json)
        Representer::Airport.new(OpenStruct.new)
          .from_json(airport_json)
          .then { |airport| Success(airport) }
      end
    end
  end
end
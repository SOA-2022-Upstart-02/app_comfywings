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
        puts "config: #{ComfyWings::App.config.API_HOST}"
        result = Gateway::Api.new(ComfyWings::App.config).get_airport(iata_code)
        puts "api url: ", result
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('could not access our API')
      end

      def reify_airport(airport_json)
        Representer::Airport.new(OpenStruct.new)
          .from_json(airport_json)
          .then { |airport| Success(airport) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
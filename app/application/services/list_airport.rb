# frozen_string_literal: true

require 'dry/transaction'
require 'digest'

module ComfyWings
  module Service
    # Retrieves array of all currencies
    class RetrieveAirportsList
      include Dry::Transaction

      step :retrieve_airportlist

      private

      DB_ERR = 'We encountered an issue accessing the database.'

      def retrieve_airportlist(iata_letter_code)
        result = Gateway::Api.new(ComfyWings::App.config).get_airport_list(iata_letter_code)
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get list of airports')
      end
    end
  end
end

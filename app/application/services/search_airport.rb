# frozen_string_literal: true

require 'dry/transaction'

module ComfyWings
  module Service
    # Transaction to store project from Github API to database
    class SearchAirport
      include Dry::Transaction

      step :validate_input
      step :request_airport

      private

      def validate_input(input)
        if input.success?
          Success(airport_iata_code:)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def request_airport(input)
        result = Gateway::Api.new(CodePraise::App.config)
          .get_airport(input)

        result.success? ? Success(result.payload) : Failure(result.message)
      end
    end
  end
end
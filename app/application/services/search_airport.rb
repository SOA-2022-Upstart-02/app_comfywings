# frozen_string_literal: true

require 'dry/transaction'

module ComfyWings
  module Service
    # retrieves queried airport entitiy
    class FindAirports
      include Dry::Transaction

      step :find_airport

      def find_airport(input)
        airport =
          airport_in_database(input)
        Success(airport)
      rescue StandardError => e
        App.logger.error e.backtrace.join("\n")
        Failure('Having trouble with airports')
      end

      def airport_in_database(iata_code)
        Repository::For.klass(Entity::Airport).find_code(iata_code)
      end
    end
  end
end

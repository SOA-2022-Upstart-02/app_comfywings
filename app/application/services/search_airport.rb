# frozen_string_literal: true

require 'dry/transaction'

module ComfyWings
  module Service
    # retrieves queried airport entitiy
    class FindAirports
      include Dry::Transaction

      step :find_airport

      def find_airport(input)
        if input.success?
          if (airport_search = airport_in_database(input))
            success(airport_search:)
          end
        else
          Failure(input.errors.messages.first)
        end
      end

      def airport_in_database(iata_code)
        Repository::For.klass(Entity::Airport).find_code(iata_code)
      end
    end
  end
end

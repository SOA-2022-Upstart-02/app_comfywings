# frozen_string_literal: true

require 'dry/transaction'

module ComfyWings
  module Service
    # Retrieves array of trips by tripQuery code
<<<<<<< HEAD
    class SearchReturnTrips
=======
    class SearchSingleTrips
>>>>>>> single_trip_app
      include Dry::Transaction

      step :request_trips
      step :reify_trips

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      EXPIRED_MSG = 'This query is expired'
      NOT_FOUND_MSG = 'Undefined query'

      def request_trips(code)
        result = Gateway::Api.new(ComfyWings::App.config)
          .get_trips(code)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get trips')
      end

      def reify_trips(trips_json)
<<<<<<< HEAD
        Representer::ReturnTripsList.new(OpenStruct.new)
=======
        Representer::SingleTripsList.new(OpenStruct.new)
>>>>>>> single_trip_app
          .from_json(trips_json)
          .then { |trips| Success(trips) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end

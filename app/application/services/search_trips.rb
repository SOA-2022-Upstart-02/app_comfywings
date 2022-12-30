# frozen_string_literal: true

require 'dry/transaction'

module ComfyWings
  module Service
    # Retrieves array of trips by tripQuery code
    class SearchTrips
      include Dry::Transaction

      step :request_trips
      step :reify_kind_of_trips


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

      def reify_kind_of_trips(trips_json)
        response = Representer::SingleTripsList.new(OpenStruct.new)
        .from_json(trips_json)

        if response['trips'].first['inbound_flights'].nil?
          return reify_single_trips(trips_json)
        else
          return reify_return_trips(trips_json)
        end
      end

      def reify_single_trips(trips_json)
        Representer::SingleTripsList.new(OpenStruct.new)
          .from_json(trips_json)
          .then { |trips| Success(trips) }
      rescue StandardError
        Failure('Could not parse response from API')
      end

      def reify_return_trips(trips_json)
        Representer::ReturnTripsList.new(OpenStruct.new)
          .from_json(trips_json)
          .then { |trips| Success(trips) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end

# frozen_string_literal: true

require 'dry/transaction'
require 'digest'

module ComfyWings
  module Service
    # Retrieves array of all listed project entities
    class FindTrips
      include Dry::Transaction

      step :find_or_create_trip_query
      step :find_or_create_trips

      def find_or_create_trip_query(input)
        if input.success?
          if (trip_query = query_in_database(input))
            Success(trip_query:)
          else
            new_trip_query = Repository::For.klass(Entity::TripQuery).create(create_trip_query_entity(input))
            Success(new_trip_query:)
          end
        else
          Failure(input.errors.messages.first)
        end
      end

      def find_or_create_trips(input)
        trips =
          if (new_trip_query = input[:new_trip_query])
            create_trips_from_amadeus(new_trip_query)
          else
            find_trips_from_database(input[:trip_query].id)
          end
        Success(trips)
      rescue StandardError => e
        App.logger.error e.backtrace.join("\n")
        Failure('Having trouble on query trips')
      end

      def query_in_database(input)
        code = Digest::MD5.hexdigest input.to_h.to_s
        Repository::For.klass(Entity::TripQuery).find_code(code)
      end

      def create_trip_query_entity(trip_request) # rubocop:disable Metrics/MethodLength
        currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')
        code = Digest::MD5.hexdigest trip_request.to_h.to_s
        ComfyWings::Entity::TripQuery.new(
          id: nil,
          code:,
          currency:,
          origin: trip_request[:airport_origin],
          destination: trip_request[:airport_destination],
          departure_date: trip_request[:date_start],
          arrival_date: trip_request[:date_end],
          adult_qty: trip_request[:adult_qty],
          children_qty: trip_request[:children_qty],
          is_one_way: false # TODO: change from trip_request
        )
      end

      def create_trips_from_amadeus(trip_query)
        trips = Amadeus::TripMapper.new(App.config.AMADEUS_KEY, App.config.AMADEUS_SECRET).search(trip_query)
        ComfyWings::Repository::For.klass(Entity::Trip).create_many(trips)
      end

      def find_trips_from_database(query_id)
        ComfyWings::Repository::For.klass(Entity::Trip).find_query_id(query_id)
      end
    end
  end
end

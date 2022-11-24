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
          h = {}
          if (trip_query = query_in_database(input))
            h[:trip_query] = trip_query
          else
            new_trip_query = Repository::For.klass(Entity::TripQuery).create(create_trip_query_entity(input))
            h[:new_trip_query] = new_trip_query
          end
          Success(h)
        else
          Failure(input.errors.messages.first)
        end
      end

      def find_or_create_trips(input)
        trips =
          if (trip_query = input[:new_trip_query])
            trips = Amadeus::TripMapper.new(App.config.AMADEUS_KEY, App.config.AMADEUS_SECRET).search(trip_query)
            ComfyWings::Repository::For.klass(Entity::Trip).create_many(trips)
          else
            ComfyWings::Repository::For.klass(Entity::Trip).find_query_id(input[:trip_query].id)
          end
        Success(trips)
      rescue StandardError => e
        App.logger.error e.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end

      def query_in_database(input)
        code = Digest::SHA256.hexdigest input.to_h.to_s
        Repository::For.klass(Entity::TripQuery).find_code(code)
      end

      def create_trip_query_entity(trip_request) # rubocop:disable Metrics/MethodLength
        currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')
        code = Digest::SHA256.hexdigest trip_request.to_h.to_s
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
          is_one_way: false
        )
      end
    end
  end
end

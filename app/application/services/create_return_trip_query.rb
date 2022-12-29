# frozen_string_literal: true

require 'dry/transaction'
require 'digest'
require 'json'

module ComfyWings
  module Service
    # Retrieves or creates trips
    class CreateReturnTripQuery
      include Dry::Transaction

      MAX_TRAVELERS = 9
      MIN_TRAVELERS = 1

      step :validate_trip_query
      step :validate_date_start
      step :validate_date_end
      step :validate_qty
      step :create_trip_query
      step :reify_trip_query

      def validate_trip_query(input)
        if input.success?
          Success(input.to_h)
        else
          Failure(input.errors.messages.first)
        end
      end

      def validate_date_start(input)
        if input[:date_start] > Date.today
          Success(input)
        else
          Failure('Must be in the future')
        end
      end

      def validate_date_end(input)
        unless input[:is_one_way]
          return Failure('Must be filled') if input[:date_end].empty?
          return Failure('Must be in the future') if Date.parse(input[:date_end]) <= Date.today
          return Failure('Must be after start date') if Date.parse(input[:date_end]) <= input[:date_start]
        end
        Success(input)
      end

      def validate_qty(input)
        if input[:adult_qty] + input[:children_qty] > MAX_TRAVELERS
          Failure("Maximum number of passengers is #{MAX_TRAVELERS}")
        elsif input[:adult_qty] + input[:children_qty] < MIN_TRAVELERS
          Failure("Minimum number of passengers is #{MIN_TRAVELERS}")
        else
          Success(input)
        end
      end

      def create_trip_query(input)
        new_trip_query = create_new_trip_query(input)
        result = Gateway::Api.new(ComfyWings::App.config).create_trip_query(new_trip_query)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        App.logger.error e.backtrace.join("\n")
        Failure('123')
      end

      def reify_trip_query(trip_query_json)
        Representer::ReturnTripQuery.new(OpenStruct.new)
          .from_json(trip_query_json)
          .then { |trip_query| Success(trip_query) }
      rescue StandardError
        Failure('Could not parse response from API')
      end

      def create_new_trip_query(trip_request)
        {
          origin: trip_request[:airport_origin],
          destination: trip_request[:airport_destination],
          departure_date: trip_request[:date_start],
          arrival_date: trip_request[:date_end],
          adult_qty: trip_request[:adult_qty],
          children_qty: trip_request[:children_qty],
          currency: trip_request[:currency],
          is_one_way: trip_request[:is_one_way]
        }
      end
    end
  end
end

# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

# require_relative 'flight'

module ComfyWings
  module Entity
    # class for trip entities
    class Trip < Dry::Struct
      include Dry.Types

      attribute :id,                  Integer.optional
      attribute :query_id,            Strict::Integer
      attribute :currency,            Currency
      attribute :origin,              Strict::String
      attribute :destination,         Strict::String
      attribute :inbound_duration,    Strict::String
      attribute :outbound_duration,   Strict::String
      attribute :price,               Strict::Decimal   # TODO: Extract as Value Object
      attribute :is_one_way,          Strict::Bool 
      attribute :flights,             Strict::Array.of(Flight)

      def outbound_duration_form
        ActiveSupport::Duration.parse(duration).parts
      end

      def outbound_flights
        flights.select { |flight| !flight.is_return }
      end

      def outbound_departure_time
        '456'
      end

      def outbound_arrival_time
        '456'
      end

      def inbound_duration_form
        ActiveSupport::Duration.parse(duration).parts
      end

      def inbound_flights
        flights.select { |flight| flight.is_return }
      end

      def inbound_departure_time
        '123'
      end

      def inbound_arrival_time
        '123'
      end
      
      def one_way?
        is_one_way
      end

      def to_attr_hash
        to_hash.except(:id, :currency, :flights)
      end
    end
  end
end

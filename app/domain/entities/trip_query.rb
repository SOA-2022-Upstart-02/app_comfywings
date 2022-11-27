# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module ComfyWings
  module Entity
    # Domain entity for trip query arg
    class TripQuery < Dry::Struct
      include Dry.Types

      attribute :id,             Integer.optional
      attribute :code,           Strict::String
      attribute :currency,       Currency
      attribute :origin,         Strict::String
      attribute :destination,    Strict::String
      attribute :departure_date, Strict::Date
      attribute :arrival_date,   Strict::Date
      attribute :adult_qty,      Strict::Integer
      attribute :children_qty,   Strict::Integer
      attribute :is_one_way,     Strict::Bool

      def create_amadeus_flight_offers
        {
          currencyCode: currency.code,
          originDestinations:
            is_one_way ? [create_outbound_destinations] : [create_outbound_destinations, create_inbound_destinations],
          travelers: create_travelers,
          sources: ['GDS']
        }
      end

      def to_attr_hash
        to_hash.except(:id, :currency)
      end

      private

      def create_outbound_destinations
        {
          id: 1,
          originLocationCode: origin,
          destinationLocationCode: destination,
          departureDateTimeRange: {
            date: departure_date
          }
        }
      end

      def create_inbound_destinations
        {
          id: 2,
          originLocationCode: destination,
          destinationLocationCode: origin,
          departureDateTimeRange: {
            date: arrival_date
          }
        }
      end

      def create_travelers
        create_adult_travelers + create_child_travelers
      end

      def create_adult_travelers
        (1..adult_qty).map { |num| { id: num, travelerType: 'ADULT' } }
      end

      def create_child_travelers
        (1..children_qty).map { |num| { id: num + adult_qty, travelerType: 'CHILD' } }
      end
    end
  end
end

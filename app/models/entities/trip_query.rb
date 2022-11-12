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

      def to_attr_hash
        to_hash.except(:id, :currency)
      end
    end
  end
end

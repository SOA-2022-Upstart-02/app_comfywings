# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

require_relative 'flight'

module ComfyWings
  module Entity
    class TripQuery < Dry::Struct
      include Dry.Types

      attribute :id,             Integer.optional
      attribute :code,           Strict::String
      attribute :currency,       Currency
      attribute :origin,         Strict::String
      attribute :destination,    Strict::String
      attribute :departure_date, Strict::DateTime
      attribute :arrival_date,   Strict::DateTime
      attribute :adult_qty,      Strict::Integer
      attribute :children_qty,   Strict::Integer
      attribute :is_one_way,     Strict::Bool
    end
  end
end

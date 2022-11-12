# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

# require_relative 'flight'

module ComfyWings
  module Entity
    # class for trip entities
    class Trip < Dry::Struct
      include Dry.Types


      attribute :id,              Integer.optional
      attribute :origin,          Strict::String
      attribute :destination,     Strict::String
      attribute :departure_date,  Strict::String
      attribute :arrival_date,    Strict::String
      attribute :is_one_way,      Strict::Bool
      #attribute :adult_qty,       Strict::Integer
      #attribute :children_qty,    Strict::Integer

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end

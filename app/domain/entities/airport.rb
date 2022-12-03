# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module ComfyWings
  module Entity
    # Domain entity for aiport info
    class Airport < Dry::Struct
      include Dry.Types

      attribute :id,                 Integer.optional
      attribute :airport_name,       Strict::String
      attribute :city_airport_name,  Strict::String
      attribute :country,            Strict::String
      attribute :iata_code,          Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end

# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module ComfyWings
  module Entity
    # class for currency entity
    class Currency < Dry::Struct
      include Dry.Types

      attribute :id,   Integer.optional
      attribute :name, Coercible::Array#Strict::String
      attribute :code, Coercible::Array#Strict::String

      def to_attr_hash
        to_hash.except(:id) 
      end
    end
  end
end

# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module ComfyWings
  module Entity
    # Domain entity for currency
    class Currency < Dry::Struct
      include Dry.Types

      attribute :id,   Integer.optional
      attribute :code, Strict::String
      attribute :name, Strict::String

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end

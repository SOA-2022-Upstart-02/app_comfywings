# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module ComfyWings
  module Entity
    # class for currency entity
    class Currency < Dry::Struct
      include Dry.Types

      attribute :id,   Integer.optional
      attribute :code, Strict::String
      attribute :name, Strict::String
    end
  end
end

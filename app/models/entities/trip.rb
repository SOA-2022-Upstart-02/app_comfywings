# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

require_relative 'flight'

module ComfyWings
  module Entity
    class Trip < Dry::Struct
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :origin,        Strict::String
      attribute :destination,   Strict::String
      attribute :duration,      Strict::String
      attribute :price,         Strict::String
      attribute :currency,      Strict::String
      attribute :flights,       Strict::Array.of(Flight)
    end
  end
end

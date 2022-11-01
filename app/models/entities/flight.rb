# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module ComfyWings
  module Entity
    class Flight < Dry::Struct
      include Dry.Types

      attribute :origin,        Strict::String
      attribute :destination,   Strict::String
      attribute :duration,      Strict::String
    end
  end
end

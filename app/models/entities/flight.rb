# frozen_string_literal: false

require 'dry-struct'
require 'dry-types'

module ComfyWings
  module Entity
    # class for flight entitity
    class Flight < Dry::Struct
      include Dry.Types

      attribute :id,          Integer.optional
      attribute :origin,      Strict::String
      attribute :destination, Strict::String
      attribute :duration,    Strict::String
    end
  end
end

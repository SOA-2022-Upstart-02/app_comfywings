# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module ComfyWings
  # Domain entity for aiport info
  module Entity
    class Airport < Dry::Struct
      include Dry.Types

      attribute :type,      String.optional
      attribute :subtype,   Strict::String
      attribute :name,      Strict::String
      attribute :iata_code, Strict::String
    end
  end
end
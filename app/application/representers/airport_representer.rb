# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module ComfyWings
  module Representer
    # Representer for airport
    class Airport < Roar::Decorator
      include Roar::JSON

      property :airport_name
      property :city_airport_name
      property :country
      property :iata_code
    end
  end
end

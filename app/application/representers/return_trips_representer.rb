# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'return_trip_representer'

module ComfyWings
  module Representer
    # Represents list of Trip for API output
    class ReturnTripsList < Roar::Decorator
      include Roar::JSON

      collection :trips, extend: Representer::ReturnTrip, class: Representer::OpenStructWithLinks
    end
  end
end

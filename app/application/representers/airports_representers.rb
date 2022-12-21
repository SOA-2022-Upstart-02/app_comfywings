# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'airport_representer'

module ComfyWings
  module Representer
    # Represents list of currencies
    class AirportList < Roar::Decorator
      include Roar::JSON

      collection :airports, extend: Representer::Airport, class: Representer::OpenStructWithLinks
    end
  end
end

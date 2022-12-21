# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module ComfyWings
  module Representer
    # Representer for Currency entities
    class Currency < Roar::Decorator
      include Roar::JSON

      property :code
      property :name
    end
  end
end

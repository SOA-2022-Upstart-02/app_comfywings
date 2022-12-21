# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'airport_representers'

module ComfyWings
  module Representer
    # Represent Flight as Json
    class Flight < Roar::Decorator
      include Roar::JSON

      property :origin, extend: Representer::Airport, class: OpenStruct
      property :destination, extend: Representer::Airport, class: OpenStruct
      property :duration_form
      property :aircraft
      property :number
      property :departure_time
      property :arrival_time
      property :cabin_class
    end
  end
end

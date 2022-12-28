# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'flight_representer'

module ComfyWings
  module Representer
    # Represent TripQuery as Json
    class ReturnTripQuery < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :id
      property :code
      property :currency, extend: Representer::Currency, class: OpenStruct
      property :origin, extend: Representer::Airport, class: OpenStruct
      property :destination, extend: Representer::Airport, class: OpenStruct
      property :departure_date
      property :arrival_date
      property :adult_qty
      property :children_qty
      property :is_one_way

      # link :self do
      # end
    end
  end
end

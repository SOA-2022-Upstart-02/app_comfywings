# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'flight_representer'

module ComfyWings
  module Representer
    # Represent Trip as Json
    class Trip < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :id
      property :query_id
      property :currency, extend: Representer::Currency, class: OpenStruct
      property :origin, extend: Representer::Airport, class: OpenStruct
      property :destination, extend: Representer::Airport, class: OpenStruct
      property :outbound_duration_form
      property :outbound_departure_time
      property :outbound_arrival_time
      property :inbound_duration_form
      property :inbound_departure_time
      property :inbound_arrival_time
      property :price_form
      collection :outbound_flights, extend: Representer::Flight, class: OpenStruct
      collection :inbound_flights, extend: Representer::Flight, class: OpenStruct

      # link :self do
      # end
    end
  end
end

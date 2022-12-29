# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'flight_representer'

module ComfyWings
  module Representer
    # Represent TripQuery as Json
<<<<<<<< HEAD:app/application/representers/return_trip_query_representer.rb
    class ReturnTripQuery < Roar::Decorator
========
    class SingleTripQuery < Roar::Decorator
>>>>>>>> single_trip_app:app/application/representers/single_trip_query_representer.rb
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :id
      property :code
      property :currency, extend: Representer::Currency, class: OpenStruct
      property :origin, extend: Representer::Airport, class: OpenStruct
      property :destination, extend: Representer::Airport, class: OpenStruct
      property :departure_date
<<<<<<<< HEAD:app/application/representers/return_trip_query_representer.rb
      property :arrival_date
========
>>>>>>>> single_trip_app:app/application/representers/single_trip_query_representer.rb
      property :adult_qty
      property :children_qty
      property :is_one_way

      # link :self do
      # end
    end
  end
end

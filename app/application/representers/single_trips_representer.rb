# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
<<<<<<<< HEAD:app/application/representers/return_trips_representer.rb
require_relative 'return_trip_representer'
========
require_relative 'single_trip_representer'
>>>>>>>> single_trip_app:app/application/representers/single_trips_representer.rb

module ComfyWings
  module Representer
    # Represents list of Trip for API output
<<<<<<<< HEAD:app/application/representers/return_trips_representer.rb
    class ReturnTripsList < Roar::Decorator
      include Roar::JSON

      collection :trips, extend: Representer::ReturnTrip, class: Representer::OpenStructWithLinks
========
    class SingleTripsList < Roar::Decorator
      include Roar::JSON

      collection :trips, extend: Representer::SingleTrip, class: Representer::OpenStructWithLinks
>>>>>>>> single_trip_app:app/application/representers/single_trips_representer.rb
    end
  end
end

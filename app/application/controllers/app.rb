# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

# Remove this line once integrated with api
require 'yaml'

module ComfyWings
  # Main controller class for ComfyWings
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # enable other HTML verbs such as PUT/DELETE
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css'
    plugin :common_logger, $stderr

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        currency_list = Repository::For.klass(Entity::Currency).all
        view 'home', locals: { currencies: currency_list }
      end

      routing.is 'flight' do
        # POST /flight
        routing.post do
          trip_request = Forms::NewTripQuery.new.call(routing.params)
          trips = Service::FindTrips.new.call(trip_request)
          if trips.failure?
            flash[:error] = trips.failure
            response.status = 400
            routing.redirect '/'
          end
          view 'flight', locals:
          {
            trips: trips.value!,
            trip_request: trip_request.values
          }
        end
      end

      routing.is 'airport' do
        # GET /airport
        view 'airport', locals: {}
      end
      # routing.get do
        routing.on do
        #   searched_airports = Service::RetrieveAirportsList.new.call(routing.params["iata_code"])
          list_airport = searched_airports.value!

          airportlist = Views::AirportList.new(list_airport["airports"])

        #   view 'individual_airport', locals: { airportlist: }
        # end
      end
    end
  end
end

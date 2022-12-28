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

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        # currency_list = Repository::For.klass(Entity::Currency).all
        currency_list = Service::RetrieveCurrencies.new.call

        if currency_list.failure?
          flash[:error] = currency_list.failure
          currencies = []
        else
          currencies = currency_list.value!.currencies
        end

        view 'home', locals: { currencies: }
      end

      routing.on 'trips' do
        routing.on String do |code|
          routing.get do
            result = Service::SearchSingleTrips.new.call(code)

            if result.failure?
              flash[:error] = result.failure
              trips = []
            else
              trips = result.value!.trips
            end

            view 'trip', locals: { trips: }
          end
        end
      end

      routing.is 'trip_query' do
        routing.post do
          routing.params['is_one_way'] = routing.params['is_one_way'] ? true : false
          trip_request = Forms::NewTripQuery.new.call(routing.params)
          result = Service::CreateSingleTripQuery.new.call(trip_request)
          if result.failure?
            flash[:error] = result.failure
            response.status = 400
            routing.redirect '/'
          else
            routing.redirect "trips/#{result.value!['code']}"
          end
        end
      end

      routing.is 'airport' do
        # GET /airport
        view 'airport', locals: {}
      end
      routing.get do
        routing.on do
          searched_airports = Service::RetrieveAirportsList.new.call(routing.params['iata_code'])
          list_airport = searched_airports.value!
          airportlist = Views::AirportList.new(list_airport['airports'])
          view 'individual_airport', locals: { airportlist: }
        end
      end
    end
  end
end

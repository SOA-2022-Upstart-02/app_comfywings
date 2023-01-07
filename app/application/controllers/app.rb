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
                    css: ['style.css', 'autocomplete.css'], js: 'airport-autocomplete.js'
    plugin :common_logger, $stderr

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
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
            result = Service::SearchTrips.new.call(code:, sort: routing.params['sorting'])
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
          result = Service::CreateTripQuery.new.call(trip_request)

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
        routing.get do
          routing.on do
            result = Service::RetrieveAirportsList.new.call(routing.params['iata_code'])

            if result.failure?
              flash[:error] = result.failure
            else
              result.value!.to_json
            end
          end
        end
      end
    end
  end
end

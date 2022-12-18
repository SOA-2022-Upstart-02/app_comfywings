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
        # view 'home', locals: { currencies: currency_list }
      end

      routing.on 'trips' do
        routing.on String do |code|
          routing.get do
            result = Service::SearchTrips.new.call(code)

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

      routing.is 'airport' do
        # GET /airports
        routing.is do
          first_airport = Repository::For.klass(Entity::Airport).first
          view 'airport', locals: { airport: first_airport }
        end
        #  TODO: fix code to ensure all airports are obtained through search
        # routing.is aiport_search do
        # routing.post do
        #  airport_code = Forms::SearchAirport.new.call(routing.params)
        #  airport = Service::FindAirports.new.call(airport_code)
        # view 'airport_search', locals: { airport_info: airport.value! }
        # end
        #  end
      end
    end
  end
end

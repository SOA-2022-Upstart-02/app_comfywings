require 'roda'
require 'slim'

# Remove this line once integrated with api
require 'yaml'

module ComfyWings
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'airport' do
        routing.is do
          routing.post do
            view 'airport'
          end
        end

        routing.on String do
          routing.get do
            amadeus_airport = Amadeus::AirportMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
          end
        end
      end

      routing.is 'flight' do
        # routing.is do
        #   # POST /flight/
        #   routing.post do

        #   end
        # end

        # routing.on String, String do |orig, dest|
        #   # GET /flight/{origin}/{destination}
        #   routing.get do
        #     candidate_flights = Amadeus::
        #   end
        # end
        print routing.params

        # flight_results = YAML.safe_load_file('../../spec/fixtures/flight_results.yml')
        routing.post do
          from = routing.params['airport-origin']
          to = routing.params['airport-destination']
          from_date = routing.params['date-start']
          to_date = routing.params['date-end']
          trips = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
                                                 .search(from, to, from_date, to_date)
          print trips

          view 'flight', locals: { trips: }
        end
      end
    end
  end
end

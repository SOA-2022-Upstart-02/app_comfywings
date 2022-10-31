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

      routing.on 'flight' do
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

        # flight_results = YAML.safe_load_file('../../spec/fixtures/flight_results.yml')
        trip_results = [
          {
            origin: "TPE",
            destination: "CGK",
            duration: "1H15M",
            price: "NT$5000",
            flights: [{id: 1, code: "BR XXX", airline: "EVA Air"}]
          },
          {
            origin: "CGK",
            destination: "AKL",
            duration: "1H15M",
            price: "NT$8000",
            flights: [
              {id: 1, code: "QF XXX", airline: "Qantas"},
              {id: 2, code: "NZ XXX", airline: "Air New Zealand"}
            ]
          }
        ]

        view 'flight', locals: { trips: trip_results }
      end

    end
  end
end
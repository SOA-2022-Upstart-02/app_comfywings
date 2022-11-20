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
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css'
    plugin :common_logger, $stderr

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home'
      end

      routing.is 'flight' do
        # POST /flight
        routing.post do
          if routing.params['airport-origin'].empty? ||
             routing.params['airport-destination'].empty? ||
             routing.params['date-start'].empty? ||
             routing.params['date-end'].empty?
            flash[:error] = 'Input field must not be empty'
            response.status = 400
            routing.redirect '/'
          end

          from = routing.params['airport-origin']
          to = routing.params['airport-destination']
          from_date = routing.params['date-start']
          to_date = routing.params['date-end']

          trip_results = ComfyWings::Amadeus::TripMapper.new(App.config.AMADEUS_KEY, App.config.AMADEUS_SECRET)
            .search(from, to, from_date, to_date)
          view 'flight', locals: { trips: trip_results, date_range: { from: from_date, to: to_date } }
        end
      end
    end
  end
end

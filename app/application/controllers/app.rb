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
          trip_request = Forms::NewTripQuery.new.call(routing.params)
          if trip_request.failure?
            flash[:error] = trip_request.errors.messages.first
            response.status = 400
            routing.redirect '/'
          else
            # save or find trip_query
            puts trip_request.values[:airport_origin]
            # find and create trips by trip query

            # return view
          end

          # trip_results = ComfyWings::Amadeus::TripMapper.new(App.config.AMADEUS_KEY, App.config.AMADEUS_SECRET)
          #   .search(from, to, from_date, to_date)

          # # TODO : Viewable object

          # view 'flight', locals: { trips: trip_results, date_range: { from: from_date, to: to_date },
          # origin_destination: { origin: from, destination: to } }
        end
      end
    end
  end
end

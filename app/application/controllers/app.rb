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
        view 'home', locals: {}
      end

      routing.on 'airport' do
        # GET /airports
        view 'airport', locals: {}
      end
    end
  end
end

require 'roda'
require 'slim'

module ComfyWings
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # Load our custom CSS

      # GET /
      routing.root do
        view 'home'
      end

      # Get /flight
      routing.on 'flight' do
        view 'flight'
      end
    end
  end
end
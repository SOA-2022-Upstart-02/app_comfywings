# frozen_string_literal: true

# Require all ruby files in the following folders
def require_app
  Dir.glob('./{config,app}/**/*.rb').each do |file|
    require file
  end
end

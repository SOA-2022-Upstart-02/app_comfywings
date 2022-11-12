# frozen_string_literal: true

require 'http'
require 'yaml'
require 'json'

# create auth token class
class AuthToken
  # open secret yaml file
  def initialize
    @config = ComfyWings::App.config
  end

  # return the auth token
  def obtain_token
    postform = {
      grant_type: 'client_credentials',
      client_id: @config.AMADEUS_KEY,
      client_secret: @config.AMADEUS_SECRET
    }
    response = HTTP.headers(accept: 'application/x-www-form-urlencoded')
      .post(version1_url_path('security/oauth2/token'), form: postform)
    response.parse['access_token']
  end
end

def version1_url_path(path)
  "https://test.api.amadeus.com/v1/#{path}"
end

def version2_url_path(path)
  "https://test.api.amadeus.com/v2/#{path}"
end

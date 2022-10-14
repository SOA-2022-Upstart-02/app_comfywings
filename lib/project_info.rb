require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def amadeus_api_path(path)
  "https://test.api.amadeus.com/v1/#{path}"
end

def request_amadeus_auth_token(config)
  postform = {
    grant_type: 'client_credentials',
    client_id: config['AMADEUS_KEY'],
    client_secret: config['AMADEUS_SECRET']
  }
  response = HTTP.headers(accept: 'application/x-www-form-urlencoded')
                 .post(amadeus_api_path('security/oauth2/token'), form: postform)
  response.parse['access_token']
end

token = request_amadeus_auth_token(config)
print token
response = HTTP.headers(Authorization: "Bearer #{token}")
               .get(amadeus_api_path('shopping/flight-destinations?origin=PAR&maxPrice=2000000'))
print response

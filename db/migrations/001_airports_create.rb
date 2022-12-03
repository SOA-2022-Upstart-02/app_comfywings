# frozen_string_literal: true

require 'sequel'
require 'json'

airports = File.read('spec/fixtures/airports.json')
parsed = JSON.parse(airports)

Sequel.migration do
  change do
    create_table(:airports) do
      primary_key :id
      String      :airport_name
      String      :city_airport_name
      String      :country
      String      :iata_code, null: false
    end
    parsed.each do |data|
      from(:airports).insert(airport_name: data['airport_name'], city_airport_name: data['city_airport_name'],
                             country: data['country'], iata_code: data['iata_code'])
    end
  end
end

# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:airports) do
      primary_key :id
      String      :iata_code, unique: true, null: false
      String      :city_name
    end
    from(:airports).insert(iata_code: 'TPE', city_name: 'Taipei')
    from(:airports).insert(iata_code: 'MAD', city_name: 'Madrid')
  end
end

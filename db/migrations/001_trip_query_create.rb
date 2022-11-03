# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trip_query) do
      primary_key :id
      String      :code, unique: true, null: false # generate by 8 bit uuid
      String      :origin
      String      :destionation
      Date        :departure_date
      Date        :arrival_date
      String      :currency_code
      TrueClass   :is_two_way
    end
  end
end

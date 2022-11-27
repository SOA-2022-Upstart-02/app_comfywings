# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:trip_queries) do
      primary_key :id
      foreign_key :currency_id, :currencies
      String      :code, unique: true, null: false # generate by 8 bit uuid
      String      :origin
      String      :destination
      Date        :departure_date
      Date        :arrival_date
      Integer     :adult_qty
      Integer     :children_qty
      TrueClass   :is_one_way
    end

    # TODO: remove below after finish trip query feature
    from(:trip_queries).insert(currency_id: 2, code: 'temp_for_test', origin: 'TPE', destination: 'MAD',
                               departure_date: Date.parse('2022-12-31'), arrival_date: Date.parse('2023-01-29'),
                               adult_qty: 1, children_qty: 2, is_one_way: false)
    from(:trip_queries).insert(currency_id: 2, code: 'temp_for_test2', origin: 'TPE', destination: 'MAD',
                               departure_date: Date.parse('2022-12-31'), arrival_date: Date.parse('2023-01-29'),
                               adult_qty: 1, children_qty: 2, is_one_way: true)
  end
end

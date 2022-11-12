# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:currencies) do
      primary_key :id
      String      :code, unique: true, null: false
      String      :name
    end
    from(:currencies).insert(code: 'TWD', name: 'Taiwan Dollar')
    from(:currencies).insert(code: 'USD', name: 'US Dollar')
    from(:currencies).insert(code: 'EUR', name: 'EURO')
    from(:currencies).insert(code: 'GBP', name: 'British Pound')
  end
end

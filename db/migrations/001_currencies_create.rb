# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:currencies) do
      primary_key :id
      String      :code, unique: true, null: false
      String      :name
    end
    from(:currencies).insert(code: 'TWD', name: 'New Taiwan dollar')
    from(:currencies).insert(code: 'USD', name: 'United States dollar')
    from(:currencies).insert(code: 'EUR', name: 'Euro')
    from(:currencies).insert(code: 'GBP', name: 'Pound sterling')
  end
end

# frozen_string_literal: true

require 'dry-validation'

module ComfyWings
  module Forms
    # Form object for aiport query from user
    class SearchAirport < Dry::Validation::Contract
      params do
        required(:iata_code).filled(:string)
      end

      rule(:iata_code) do
        key.failure('Must be of type string') unless is_string?
      end
    end
  end
end

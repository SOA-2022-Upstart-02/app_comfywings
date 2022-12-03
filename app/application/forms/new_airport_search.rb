# frozen_string_literal: true

require 'dry-validation'

module ComfyWings
  module Forms
    # Form object for aiport query from user
    class SearchAirport < Dry::Validation::Contract
      params do
        required(:airport_code).filled(:string)
      end

      rule(:airport_code) do
        key.failure('must be of type string')
      end
    end
  end
end

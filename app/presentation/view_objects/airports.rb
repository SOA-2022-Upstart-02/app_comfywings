# frozen_string_literal: true

module Views
  # class for trip info
  class Airport
    def initialize(iata_code)
      @org_iata_code = iata_code
    end

    def airport_name
      @org_iata_code
    end

    def city_airport_name
      @org_iata_code
    end

    def country
      @org_iata_code
    end

    def iata_code
      @org_iata_code
    end
  end
end

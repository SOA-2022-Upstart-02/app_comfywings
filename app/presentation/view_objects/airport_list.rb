# frozen_string_literal: true

require_relative 'airport'

module Views
  # class for list of arrays
  class AirportList
    def initialize(airport_list)
      @list = airport_list
    end

    def airports(list)
      list.map do |airport|
        Airport.new(airport)
      end
    end
  end
end
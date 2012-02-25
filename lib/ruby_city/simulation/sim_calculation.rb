$:.unshift(File.dirname(__FILE__))

require 'singleton'

module RubyCity
  class SimCalculation
    include Singleton

    def initialize
      @params = {
        # base capacity for population for 1.0 building
        building_residential_capacity: 4.0,
        # initial amount of residential building in city
        initial_buildings_residential: 10.0
      }
    end

    def calculate_residential_capacity_happiness(capacity, current_population)
      space_left = capacity - current_population
      h = 1.0 - 0.5*(current_population / (capacity + 0.5))
      n(h)
    end

    attr_reader :params

    # Normalize value for range from 0.0 to 1.0
    def normalize(v)
      return 1.0 if v >= 1.0
      return 0.0 if v <= 0.0
      return v
    end

    alias_method :n, :normalize

  end
end
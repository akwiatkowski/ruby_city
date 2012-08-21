$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Infrastructure < CityBase
    def initialize(_city)
      @type = :common
      @cost_per_population = 0.0
      @cost_const = 0.0
      @city = _city
    end

    attr_reader :type, :cost_per_population, :cost_const, :city

    def to_s
      str = "Infrastructure: #{type} \n"
      str += " cost per population: #{cost_per_population}\n"
      str += " const. cost: #{cost_const}\n"

      str
    end

    def total_cost
      cost_per_population * city.population.count + cost_const
    end

  end
end

require 'infrastructure/power_plant'
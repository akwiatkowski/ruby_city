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
        initial_buildings_residential: 10.0,
        # amount of money generated by person
        income_per_person: 5.0,
        # initial amount of people in outside world which can be used for initial migration
        outside_world_initial_population: 100,
        # how much money earned from tax should be auto. spend
        auto_money_spend: {
          residential: 0.3
        },
        # various building cost
        building_cost: {
          residential: 5.0
        }
      }
    end

    attr_reader :params

    # Calculate happiness for residential capacity
    def calculate_residential_capacity_happiness(capacity, current_population)
      space_left = capacity - current_population
      h = 1.0 - 0.5*(current_population / (capacity + 0.5))
      n(h)
    end

    # Calculate possible immigration
    def calculate_population_immigration(capacity, current_population, happiness)
      space_left = capacity - current_population
      h = happiness - 0.5
      sign_change = 1.0
      sign_change = -1.0 if space_left < 0 and h < 0
      g = h * space_left * sign_change
      return g
    end

    # Calculate possible immigration
    def calculate_population_biological_growth(current_population, happiness)
      # TODO add test
      _min = 0.02
      _max = 0.15
      # TODO some nonlinear please
      coeff = (happiness - 0.2) * 0.2
      coeff = _min if coeff < _min
      coeff = _max if coeff > _max
      (coeff * current_population).to_f.floor
    end

    def calculate_population_income(current_population)
      current_population * params[:income_per_person]
    end

    def calculate_tax_happiness(tax)
      h = 1.0 - tax
      h = n(h)
      h = h ** 2.3
      return h
    end

    attr_reader :params

    # Normalize value for range from 0.0 to 1.0
    def normalize(v)
      return 1.0 if v >= 1.0
      return 0.0 if v <= 0.0
      return v
    end

    alias_method :n, :normalize

    def calculate_auto_build_residential_spending(_surplus)
      raise ArgumentError if _surplus.nil?
      return _surplus * @params[:auto_money_spend][:residential]
    end

  end
end
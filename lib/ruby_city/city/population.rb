$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Population < CityBase
    def init
      @count = 0
      @last_count = @count
    end

    # Population count, and count in previous turn
    attr_reader :count, :last_count

    def to_s
      str = "Population: \n"
      str += " count: #{count}\n"
      str += " capacity: #{capacity}\n"
      str += " happiness: #{happiness}\n"

      str
    end

    # Space calculated using building capacity
    def capacity
      SimCalculation.instance.params[:building_residential_capacity] * parent.buildings.residential
    end

    # Space left
    def space_left
      capacity - count
    end

    def possible_immigration
      SimCalculation.instance.calculate_population_immigration(capacity, count, city.happiness)
    end

    def add_immigration(outside_world, amount)
      raise ArgumentError unless outside_world.class == OutsideWorld
      @count += amount
    end

    def possible_growth
      SimCalculation.instance.calculate_population_biological_growth(count, city.happiness)
    end

    def next_turn
      population_growth_by_turn
    end

    # Happiness calculated using residential capacity
    def happiness
      SimCalculation.instance.calculate_residential_capacity_happiness(capacity, count)
    end

    private

    # Biological growth of population
    def population_growth_by_turn
      @count += possible_growth
    end

  end
end
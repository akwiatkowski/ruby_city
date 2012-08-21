$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Population < CityBase
    def init
      @count = 0
      @last_count = @count

      # other things which modify happiness
      @happiness_mods = Hash.new
    end

    # Population count, and count in previous turn
    attr_reader :count, :last_count

    def to_s
      str = "Population: \n"
      str += " count: #{count}\n"
      str += " capacity: #{capacity}\n"
      str += " residential happiness: #{residential_happiness}\n"
      str += " happiness w infr.: #{happiness}\n"

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
      # reset this factor
      @happiness_coeff = 1.0

      population_growth_by_turn
    end

    # Happiness calculated using residential capacity
    def residential_happiness
      SimCalculation.instance.calculate_residential_capacity_happiness(capacity, count)
    end

    def happiness
      residential_happiness * happiness_coeff
    end

    def modify_happiness(_type, _factor)
      @happiness_mods[_type] = _factor
    end

    # Current happiness modificator/factor/coefficient
    def happiness_coeff
      @happiness_coeff = 1.0
      @happiness_mods.values.each do |_mod|
        @happiness_coeff *= _mod
      end
      return @happiness_coeff
    end

    private

    # Biological growth of population
    def population_growth_by_turn
      @count += possible_growth
    end

  end
end
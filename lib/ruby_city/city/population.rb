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

    def next_turn
      population_growth_by_turn
    end

    # Happiness calculated using residential capacity
    def happiness
      SimCalculation.instance.calculate_residential_capacity_happiness(capacity, count)
    end

    private

    # City growth every turn because of happiness up to max capacity
    def population_growth_by_turn
      @last_count = @count
      @count += SimCalculation.instance.calculate_population_growth(capacity, count, city.happiness)
    end


  end
end
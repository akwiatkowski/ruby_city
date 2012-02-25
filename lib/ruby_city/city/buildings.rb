$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Buildings < CityBase
    def init
      @residential = SimCalculation.instance.params[:initial_buildings_residential]
    end

    attr_reader :residential

    def to_s
      str = "Buildings: \n"
      str += " residential: #{residential}"
    end

    def build(amount, type = :residential)
      @residential += amount.to_f
    end

    #def population
    #  parent.population
    #end

    #
    def residential_capacity_happiness
      SimCalculation.instance.calculate_residential_capacity_happiness(
        population.capacity,
        population.count
      )
    end

    def next_turn
      # TODO
    end

  end
end
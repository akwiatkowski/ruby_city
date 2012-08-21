$:.unshift(File.dirname(__FILE__))

module RubyCity
  class PowerPlant < Infrastructure

    @@type = :power_plant

    def cost_per_population
      0.12
    end

    def cost_const
      0.2
    end

    def happiness_factor
      1.05
    end

    def next_turn
      # financial stuff
      super
      # other benefits
      city.population.modify_happiness(type, happiness_factor)
    end

  end
end
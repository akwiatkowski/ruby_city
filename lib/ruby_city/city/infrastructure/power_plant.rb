$:.unshift(File.dirname(__FILE__))

module RubyCity
  class PowerPlant < Infrastructure
    def cost_per_population
      0.12
    end

    def cost_const
      0.2
    end

  end
end
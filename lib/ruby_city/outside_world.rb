$:.unshift(File.dirname(__FILE__))

require 'simulation/sim_calculation'

# Everything that is not inside simulation but simulation has some relation to it
module RubyCity
  class OutsideWorld

    def initialize(_simulation)
      @population = SimCalculation.instance.params[:outside_world_initial_population]
      @simulation = _simulation

      reset_migration
    end

    attr_reader :population, :simulation

    def reset_migration
      @migration_array = Array.new
    end

    def migration_array
      # can't be modified
      @migration_array.clone
    end

    def register_migration
      reset_migration

      simulation.cities.each do |city|
        @migration_array << { city: city, happiness: city.happiness }
      end
    end

  end
end
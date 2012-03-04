$:.unshift(File.dirname(__FILE__))

require 'simulation/sim_calculation'

# Everything that is not inside simulation but simulation has some relation to it
module RubyCity
  class OutsideWorld

    def initialize(_simulation)
      @population = SimCalculation.instance.params[:outside_world_initial_population]
      @simulation = _simulation
    end

    attr_reader :population

    attr_reader :simulation

    def reset_migration
      @migration_array = Array.new
    end

  end
end
$:.unshift(File.dirname(__FILE__))

require 'simulation/sim_calculation'

module RubyCity
  class Simulation

    def initialize
      @cities = Array.new
      @turn = 0
      @outside_world = OutsideWorld.new(self)
    end

    attr_reader :cities, :turn, :outside_world

    def build_city(options = { })
      @cities << City.new(options)
    end

    # Advance turn/time for one unit
    def next_turn(_turns = 1)
      _turns.times do
        # next turn please
        @cities.each do |c|
          c.next_turn
        end
        @turn += 1

        outside_world.register_migration
      end
    end

  end
end
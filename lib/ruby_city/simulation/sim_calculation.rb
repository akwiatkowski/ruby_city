$:.unshift(File.dirname(__FILE__))

require 'singleton'

module RubyCity
  class SimCalculation
    include Singleton
    
    def initialize
      @coeff = {
        # base capacity for population for 1.0 building
        building_residential_capacity: 4.0
      }
    end

    attr_reader :coeff


  end
end
$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Population < CityBase
    def init
      @count = 0
    end

    attr_reader :count

    def to_s
      str = "Population: \n"
      str += " count: #{count}\n"
      str += " capacity: #{capacity}\n"

      str
    end

    def capacity
      SimCalculation.instance.coeff[:building_residential_capacity] * parent.buildings.residential
    end


  end
end
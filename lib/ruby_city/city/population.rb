$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Population < CityBase
    def init
      @count = 0
    end

    attr_reader :count

    def to_s
      str = "Population: \n"
      str += " count: #{count}"
    end

  end
end
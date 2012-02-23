$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Buildings < CityBase
    def init
      @residential = 0.0
    end

    attr_reader :residential

    def to_s
      str = "Buildings: \n"
      str += " residential: #{residential}"
    end

  end
end
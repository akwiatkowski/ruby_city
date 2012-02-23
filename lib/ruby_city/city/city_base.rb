module RubyCity
  class CityBase

    def initialize(_parent)
      @parent = _parent
    end

    attr_reader :parent

  end
end
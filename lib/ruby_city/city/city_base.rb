module RubyCity
  class CityBase

    def initialize(_parent)
      @parent = _parent

      # execute if available
      if self.respond_to? :init
        puts "initializing #{self.class.to_s}"
        init
      else
        puts "class #{self.class.to_s} has no initializer"
      end
    end

    attr_reader :parent

    def to_s
      "Module #{self.class.to_s}"
    end

  end
end
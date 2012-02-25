$:.unshift(File.dirname(__FILE__))

require 'city/city_base'
require 'city/population'
require 'city/buildings'

module RubyCity
  class City

    def initialize(_options = { })
      @options = _options
      reset_city

      @modules = {
        :population => Population.new(self),
        :buildings => Buildings.new(self),
      }

      # Create dynamically accessors
      @modules.each_key do |k|
        # add methods to self
        self.instance_variable_set("@#{k}".to_sym, @modules[k])
        self.class.send :define_method, k do
          instance_variable_get("@" + k.to_s)
        end

        # add methods to sub models
        @modules.each do |m|
          unless k == m
            m.instance_variable_set("@#{k}".to_sym, @modules[k])
            m.class.send :define_method, k do
              instance_variable_get("@" + k.to_s)
            end
          end
        end

      end
    end

    attr_reader :options

    def reset_city
      @name = options[:name] || "City #{self.object_id}"
    end

    def next_turn
      modules.each do |m|
        m.next_turn
      end
    end

    attr_reader :name

    def to_s
      str = "City: #{name}\n"
      @modules.values.each do |m|
        str += "#{m.to_s}\n"
      end
      str += "\n"
      return str
    end

    def modules
      @modules.values
    end

    def city
      self
    end

    # Happiness calculated using every aspect
    def happiness
      # TODO nice way to add new modules which calculate own happiness modificator
      city.population.happiness
    end

  end
end
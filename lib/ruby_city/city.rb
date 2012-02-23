$:.unshift(File.dirname(__FILE__))

require 'city/city_base'
require 'city/population'

module RubyCity
  class City

    def initialize(_options = { })
      @options = _options
      @modules = {
        :population => Population.new(self)
      }

      # Create dynamically accessors
      @modules.each_key do |k|
        self.instance_variable_set("@#{k}".to_sym, @modules[k])
        self.class.send :define_method, k do
          instance_variable_get("@" + k.to_s)
        end
      end
    end

  end
end
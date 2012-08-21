$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Infrastructure < CityBase

    @@type = :common

    def initialize(_city)
      @type = @@type
      @cost_per_population = 0.0
      @cost_const = 0.0
      @city = _city
    end

    attr_reader :type, :cost_per_population, :cost_const, :city

    def to_s
      str = "Infrastructure: #{type} \n"
      str += " cost per population: #{cost_per_population} * #{city.population.count}\n"
      str += " const. cost: #{cost_const}\n"
      str += " total cost: #{total_cost}\n"

      str
    end

    def total_cost
      cost_per_population * city.population.count + cost_const
    end

    # Account infrastructure cost
    # other benefits/effects are in proper class code
    def next_turn
      city.finance.account_operation("infrastructure_#{type}".to_sym, total_cost)
    end

    # Build all infr. for this city
    def self.build_all_infrastructures(_city)
      infrastructures.map{|k| k.new(_city)}
    end

    # List of all usable infrastructure classes
    def self.infrastructures
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

  end
end

require 'infrastructure/power_plant'
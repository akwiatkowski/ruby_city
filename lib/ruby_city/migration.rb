#$:.unshift(File.dirname(__FILE__))
#
#module RubyCity
#  class Migration
#    def init
#      @migration_plans = Array.new
#    end
#
#    def migration_plans
#      @migration_plans.clone
#    end
#
#    def register_city
#      transactions.select{|t| t[:type] == :tax}.first
#    end
#
#    def to_s
#      str = "Finance: \n"
#      str += " money: #{money}\n"
#      str += " tax: #{tax}\n"
#
#      str
#    end
#
#    # Happiness calculated using tax
#    def happiness
#      SimCalculation.instance.calculate_tax_happiness(tax)
#    end
#
#    def next_turn
#      account_tax
#    end
#
#    # Total income by population from city
#    def population_income
#      SimCalculation.instance.calculate_population_income(city.population.count)
#    end
#
#    # Tax paid by population
#    def calculate_tax
#      population_income * tax
#    end
#
#    private
#
#    # Collect and account tax from population
#    def account_tax
#      tax = calculate_tax
#      @transactions << {type: :tax, amount: tax}
#      @money += tax
#
#      return tax
#    end
#
#  end
#end
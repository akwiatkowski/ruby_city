$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Finance < CityBase
    def init
      @money = 0
      @tax = 0.1
    end

    # City money
    attr_reader :money, :tax

    def to_s
      str = "Finance: \n"
      str += " money: #{money}\n"

      str
    end

    # Happiness calculated using residential capacity
    def happiness
      SimCalculation.instance.calculate_tax_happiness(tax)
    end

    def next_turn
      calculate_tax
    end

    def population_income
      0
      #self.
    end

    private

    def calculate_tax
      population_income * tax
    end

    def account_tax
      @money += calculate_tax
    end

  end
end
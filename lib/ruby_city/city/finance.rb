$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Finance < CityBase
    def init
      new_turn_calculations

      @money = 0
      @tax = 0.1
    end

    # City money
    attr_reader :money, :tax, :turn_transactions

    def to_s
      str = "Finance: \n"
      str += " money: #{money}\n"
      str += " tax: #{tax}\n"

      str
    end

    # Happiness calculated using tax
    def happiness
      SimCalculation.instance.calculate_tax_happiness(tax)
    end

    def next_turn
      account_tax

      # last to do
      new_turn_calculations
    end

    # Total income by population from city
    def population_income
      SimCalculation.instance.calculate_population_income(city.population.count)
    end

    # Tax paid by population
    def calculate_tax
      population_income * tax
    end

    def last_turn_transaction_balance(type)
      @last_turn_transactions[type] || 0.0
    end

    def account_operation(type, amount)
      @turn_transactions << { type: type.to_s.to_sym, amount: amount }
    end

    private

    # Collect and account tax from population
    def account_tax
      account_operation(:tax, calculate_tax)
    end

    def new_turn_calculations
      # only for first execution
      @turn_transactions = Array.new if @turn_transactions.nil?

      @last_turn_transactions = Hash.new
      @turn_transactions.each do |_transaction|
        _amount = _transaction[:amount]
        @last_turn_transactions[_transaction[:type]] = @last_turn_transactions[_transaction[:type]].to_f + _amount
        @money += _amount
      end
      @turn_transactions = Array.new

      # add {:type, :amount} as transaction
      # @turn_transactions
      # it is something like this {<type> => amount, <type> amount}
      # @last_turn_transactions
    end

  end
end
$:.unshift(File.dirname(__FILE__))

module RubyCity
  class Buildings < CityBase
    def init
      @residential = SimCalculation.instance.params[:initial_buildings_residential]
      @infrastructures = Infrastructure.build_all_infrastructures(city)
    end

    attr_reader :residential

    def to_s
      str = "Buildings: \n"
      str += " residential: #{residential}"
      str = "Infrastructures: #{@infrastructures.size}\n"
      @infrastructures.each do |inf|
        str += inf.to_s
      end
      return str
    end

    def build(amount, type = :residential)
      @residential += amount.to_f
    end

    #def population
    #  parent.population
    #end

    #
    def residential_capacity_happiness
      SimCalculation.instance.calculate_residential_capacity_happiness(
        population.capacity,
        population.count
      )
    end

    def next_turn
      @infrastructures.each do |inf|
        inf.next_turn
      end

      # build stuff after turn
      auto_build
    end

    private

    # Check money income within last turn and try to spend it
    def auto_build
      # residential
      # TODO refactor it!!
      _surplus = city.finance.last_turn_income
      _money_residential = SimCalculation.instance.calculate_auto_build_residential_spending(_surplus)
      _residential_cost = SimCalculation.instance.params[:building_cost][:residential]
      _to_build = _money_residential / _residential_cost
      build(_to_build, :residential)
      city.finance.account_operation(:auto_build_residential, _money_residential)


    end

  end
end
require 'lib/city_base_class'

# All information about people living in city

class CityResidential < CityBaseClass
  BUILDING_COST_RESIDENTIAL = 5
  START_POPULATION = 0
  START_CAPACITY = 1000
  GROWTH_INERTIAL_COEF = 0.1

  attr_reader :residential_capacity, :population

  def initialize( *args )
    super( *args )
    @residential_capacity = START_CAPACITY
    @population = START_POPULATION
  end

  # accessor
  def capacity
    return @residential_capacity
  end

  # calculate and set happines to current situation
  # from 0 to 1
  def happiness
    h = 0.5

    # f(x) = 2∙(1−x^0.4), kmplot
    tax_coef = 2 * (1 - @city.finance.tax ** 0.6)
    h *= tax_coef
    # f(x) =1 − x^20
    capacity_coef = 1 - (@population.to_f / @residential_capacity.to_f) ** 20
    h *= capacity_coef

    # f(x) = (0.5+0.5∙(2∙x−1)^3)
    # f(x) = 1/(1+(x∙3)^3)

    return 1.0 if h > 1.0
    return 0.0 if h < 0.0
    return h
  end

  def growth
    # TODO
    max_possible = @residential_capacity - @population
    growth = (max_possible.to_f * GROWTH_INERTIAL_COEF) * happiness.to_f
    @growth = growth.floor
    return @growth
  end

  def next_year
    pay_taxes
    increase_population
  end

  def generate_html_report
    "
<h2>Residential</h2>
Residential Capacity: <b>#{@residential_capacity}</b><br />
Population: <b>#{@population}</b><br />
Paid tax <b>#{@tax_income}</b><br />
Growth <b>#{growth}</b><br />
    "
  end

  private

  # calculate and increase city balance
  def pay_taxes
    # was taxes paid to city?
    if @tax_income_for_year == @city.simulation.year
      # yes!
    else
      # no
      #puts @city.finance.tax
      #puts @population
      @tax_income = @city.finance.tax * @population
      @city.add_income( @tax_income )
      @tax_income_for_year = @city.simulation.year
    end
    return @tax_income
  end

  # increase amount of residents
  def increase_population
    @population += growth
  end
  













  def increase_residential( amount )
    coef = Math::log( amount.to_f )
    if coef < 1.0
      coef = 1.0
    end

    cost = (amount.to_f * BUILDING_COST_RESIDENTIAL.to_f) / coef
    if @money >= cost
      @money -= cost
      @residential_capacity += amount
      return true
    else
      return false
    end

  end
end

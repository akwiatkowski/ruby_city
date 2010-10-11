require './lib/city_base_class'
require './lib/math_utils'

# All information about people living in city

class CityResidential < CityBaseClass
  BUILDING_COST_RESIDENTIAL = 5
  START_POPULATION = 0
  START_CAPACITY = 1000
  GROWTH_INERTIAL_COEF = 0.1

  attr_reader :residential_capacity, :population, :tax_income, :city

  def initialize( *args )
    super( *args )
    @residential_capacity = START_CAPACITY
    @population = START_POPULATION
  end

  # accessor
  def capacity
    return @residential_capacity
  end

  def pollution
    Options::RESIDENTIAL_CALCULATE_POLLUTION.call( self )
  end

  def pollution_with_info
    {
      :amount => pollution,
      :type => :residential
    }
  end

  # calculate and set happines to current situation
  # from 0 to 1
  def happiness
    happiness_data = Options::RESIDENTIAL_HAPPINESS.call( self )
    @happiness_data = happiness_data
    return happiness_data[:happiness]
  end

  def growth
    # TODO
    max_possible = @residential_capacity - @population
    growth = (max_possible.to_f * GROWTH_INERTIAL_COEF) * ( happiness.to_f - 0.5 )
    @growth = growth.floor

    # safety for <0 population
    if @growth < -1 * @population
      @growth
    end
    # safety for >MAX population
    if @population + @growth > @residential_capacity
      @growth = @residential_capacity - @population
    end

    return @growth
  end

  def next_turn
    pay_taxes
    increase_population
  end

  def generate_html_report
    str = "
<h2>Residential</h2>
Residential Capacity: <b>#{residential_capacity}</b><br />
Population: <b>#{population}</b><br />
Paid tax <b>#{tax_income}</b><br />
Growth <b>#{growth}</b><br />
Happiness <b>#{happiness}</b><br />"

    str += "<div style=\"font-size: 11px;\"><ul>"
    @happiness_data[:coefs].each_pair do |k,v|
      str += "<li> "
      str += "#{k.to_s} - #{v}"
      str += "</li>"
    end
    str += "</ul></div>"

    return str
  end



  def process_http_request( action, param )
    # TODO before finish change http comm to self protocol
    case action
    when 'increase_capacity' then increase_capacity( param )
    else false
    end
  end

  def generate_html_action
    str = ""

    str += "Increase residential capacity: "
    str += "<a href=\"/#{city.id}/residential/increase_capacity/10\">10</a> "
    str += "<a href=\"/#{city.id}/residential/increase_capacity/50\">50</a> "
    str += "<a href=\"/#{city.id}/residential/increase_capacity/100\">100</a> "
    str += "<a href=\"/#{city.id}/residential/increase_capacity/200\">200</a> "

    return str
  end

  def increase_capacity( amount )
    return false if amount.to_f < 0.0

    amount = amount.to_i
    cost = residential_capacity_increase_by_unit_cost * amount.to_i
    if city.finance.balance < cost
      return false
    else
      city.finance.add_finance_operation_now( -cost, :residential_capacity_increased )
      @residential_capacity += amount
    end
  end

  def residential_capacity_increase_by_unit_cost
    BUILDING_COST_RESIDENTIAL
  end




  private

  # calculate and increase city balance
  def pay_taxes
    # was taxes paid to city?
    if @tax_income_time == @city.simulation.time
      # yes!
    else
      # no
      #puts @city.finance.tax
      #puts @population
      @tax_income = @city.finance.tax * @population
      @city.finance.add_finance_operation( @tax_income, :residential_tax )
      @tax_income_time = @city.simulation.time
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

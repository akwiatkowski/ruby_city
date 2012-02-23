require './lib/city_base_class'

class CityIndustry < CityBaseClass

  attr_reader :city, :productivity_coef, :employed, :workers

  def initialize( *args )
    super( *args )
    @productivity_coef = Options::INDUSTRY_DEFAULT_PRODUCTIVITY
    @workers = 0
  end

  def pollution
    Options::INDUSTRY_CALCULATE_POLLUTION.call( self )
  end

  def pollution_with_info
    {
      :amount => pollution,
      :type => :industry
    }
  end

  def next_turn
    pay_taxes
    increase_workers
  end

  def productivity
    Options::INDUSTRY_PRODUCTIVITY.call( self )
  end

  def max_workers
    Options::INDUSTRY_MAX_WORKERS.call( self )
  end

  def generate_html_report
    str = "
<h2>Industry</h2>
Workers: <b>#{workers}</b><br />
Max workers <b>#{max_workers}</b><br />
Productivity <b>#{productivity}</b><br />
Prod. coef. <b>#{productivity_coef}</b><br />
Polution <b>#{pollution}</b><br />"

    return str
  end

  private

  # calculate and increase city balance
  def pay_taxes
    # was taxes paid to city?
    if @tax_income_time == @city.simulation.time
      # yes!
    else
      # no
      @tax_income = city.finance.tax * productivity
      @city.finance.add_finance_operation( @tax_income, :industrial_tax )
      @tax_income_time = @city.simulation.time
    end
    return @tax_income
  end

  def increase_workers
    # TODO: move to options
    @workers = ( (max_workers - @workers) * 0.2 ).floor
  end

end

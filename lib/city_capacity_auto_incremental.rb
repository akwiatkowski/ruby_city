require './lib/city_base_class'

# Autoincrease capacity of residential zones
class CityCapacityAutoIncremental < CityBaseClass

  attr_reader :last_year_spent, :last_year_increment, :percentage_spending

  FINANCE_SYMBOL_RESIDENTIAL = :residential_capacity_increase

  def initialize( *args )
    super( *args )
    @last_year_spent = 0.0
    @last_year_increment = 0.0
    # how much of saving spend for development residential zones
    @percentage_spending = 0.0
  end

  def next_turn
    increase_residential_capacity
    spent_for_increase_residential_capacity
  end


  def generate_html_report
    "
<h2>Auto capacity incremental</h2>
Spending: <b>#{percentage_spending} %</b><br />
Last year spent: <b>#{last_year_spent}</b><br />
Last year increment: <b>#{last_year_increment}</b><br />
    "
  end

  def process_http_request( action, param )
    # TODO before finish change http comm to self protocol
    case action
    when 'set_spending' then set_spending( param )
    else false
    end
  end

  def generate_html_action
    str = ""

    str += "Set spending: "

    [-5, -2, -1, 1, 2, 5].each do |a|
      if ( percentage_spending + a ) >= 0 and (percentage_spending + a ) <= 100
        str += "<a href=\"/#{city.id}/capacity_auto_incremental/set_spending/#{percentage_spending + a}\">#{percentage_spending + a} %</a> "
      end
    end

    return str
  end

  private

  def set_spending( spending_new )
    if spending_new.to_i >= 0 and spending_new.to_i <= 100
      @percentage_spending = spending_new.to_i
    end
  end

  def spent_for_increase_residential_capacity
    @city.finance.add_finance_percentage_operation( -1.0 * @percentage_spending, FINANCE_SYMBOL_RESIDENTIAL )
  end

  def increase_residential_capacity
    @last_year_spent = -1.0 * city.finance.find_last_turn_operation_flow( FINANCE_SYMBOL_RESIDENTIAL )
    amount = @last_year_spent / city.residential.residential_capacity_increase_by_unit_cost 
    city.residential.increase_capacity( amount )
  end

end

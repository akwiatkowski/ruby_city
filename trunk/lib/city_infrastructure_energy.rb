require 'lib/city_infrastructure'
require 'lib/ai_powerplant'

class CityInfrastructureEnergy < CityInfrastructure

  attr_reader :city, :contract

  def initialize( *args )
    super( *args )

    @ai = AiPowerplant.new( self )

    # contract
    @contract = {}

    # ecological factor, 0.0 - only costs, 1.0 - only pollution
    @ecological_factor = 0.1

    # percent of potential capacity use, 0 only current, 100 full capacity
    @potential_capacity_forecast = 20.0
    # calculate demand some percents higher
    @power_reserves_percent = 20.0
  end

  def next_turn
    unless contract_valid?
      sing_new_contract
    end

    pay_supplier
  end

 



  # Calculate demand for contract
  def calculate_contract_power_demand
    d = energy_demand
    pd = potential_energy_demand

    # additional power forecast
    potential_percent_addon = (pd - d).to_f * @potential_capacity_forecast / 100.0
    demand_with_forecast = d + potential_percent_addon

    demand_with_reserve = demand_with_forecast * ( 100.0 + @power_reserves_percent ) / 100.0
    return demand_with_reserve
  end



  # Contracted power
  def energy_supply
    @contract[:total_power].to_f
  end

  # Calculate energy created by power plants
  def energy_demand
    Options::ENERGY_NEEDED_PER_CITY.call( city, city.simulation )
  end

  # Calculate energy potential demand (full capacity, winter season)
  def potential_energy_demand
    Options::ENERGY_POTENTIAL_DEMAND_PER_CITY.call( city, city.simulation )
  end

  def daily_cost
    @contract[:total_cost].to_f
  end

  def pollution
    @contract[:total_pollution].to_f
  end

  def contract_to
    @contract[:valid_to]
  end



  def generate_html_report
    "
<h2>Energy</h2>
Energy suppy: <b>#{energy_supply}</b><br />
Energy demand: <b>#{energy_demand}</b><br />
Potential energy demand: <b>#{potential_energy_demand}</b><br />
Cost daily: <b>#{daily_cost}</b><br />
Pollution: <b>#{pollution}</b><br />
Contract to: <b>#{contract_to.to_s_human_date}</b><br />
    "
  end



  private

  # If contract is valid at this moment
  def contract_valid?
    return false if contract_to.nil? or contract_to < city.simulation.time
    return true
  end

  def sing_new_contract
    @contract = @ai.select_plants_per_power(
      calculate_contract_power_demand,
      @ecological_factor,
      0.0 # tech level
    )
    @contract[:valid_to] = city.simulation.time + Options::ENERGY_CONTRACT_TIME
  end

  def pay_supplier
    @city.finance.add_finance_operation( -1.0 * daily_cost, :energy_cost )
  end

end

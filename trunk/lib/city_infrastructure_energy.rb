require 'lib/city_infrastructure'
require 'lib/ai_powerplant'

class CityInfrastructureEnergy < CityInfrastructure

  attr_reader :city, :contract, :potential_capacity_forecast, :reserves_percent,
    :ecological_factor

  def initialize( *args )
    super( *args )

    @ai = AiPowerplant.new( self )

    # contract
    @contract = {}

    # ecological factor, 0.0 - only costs, 1.0 - only pollution
    @ecological_factor = 0.2

    # percent of potential capacity use, 0 only current, 100 full capacity
    @potential_capacity_forecast = 20.0
    # calculate demand some percents higher
    @reserves_percent = 20.0
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
    potential_percent_addon = (pd - d).to_f * potential_capacity_forecast / 100.0
    demand_with_forecast = d + potential_percent_addon

    demand_with_reserve = demand_with_forecast * ( 100.0 + reserves_percent ) / 100.0
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

  def contract_type
    @contract[:type]
  end

  def energy_coverage_percent
    return 100.0 if energy_demand <= 0.0
    return (energy_supply / energy_demand) * 100.0
  end



  def generate_html_report
    "
<h2>Energy</h2>
Energy current suppy/demand: <b>#{energy_supply}</b> / <b>#{energy_demand}</b><br />
Energy coverage: <b>#{energy_coverage_percent} %</b><br /><br />

Potential energy demand: <b>#{potential_energy_demand}</b><br />
Contract calculation reserver: <b>#{reserves_percent} %</b><br />
Contract calculation capacity forecast: <b>#{potential_capacity_forecast} %</b><br /><br />

Contract type: <b>#{contract_type}</b><br />
Cost daily: <b>#{daily_cost}</b><br />
Pollution: <b>#{pollution}</b><br />
Ecological factor: <b>#{ecological_factor}</b><br />
Contract to: <b>#{contract_to.to_s_human_date}</b><br />
    "
  end


  def process_http_request( action, param )
    # TODO before finish change http comm to self protocol
    case action
    when 'set_forecast' then set_potential_capacity_forecast( param )
    when 'set_reserves' then set_power_reserves_percent( param )
    else false
    end
  end

  def generate_html_action
    str = ""

    str += "Set forecast: "
    [10, 20, 30, 40, 50, 60, 70, 80, 90, 100].each do |a|
      str += "<a href=\"/#{city.id}/energy/set_forecast/#{a}\">#{a} %</a> "
    end
    str += "<br />"

    str += "Set reserves: "
    [10, 20, 30, 40, 50].each do |a|
      str += "<a href=\"/#{city.id}/energy/set_reserves/#{a}\">#{a} %</a> "
    end
    str += "<br />"


    return str
  end

  def set_potential_capacity_forecast( f )
    if f.to_f >= 0.0 and f.to_f <= 100.0
      @potential_capacity_forecast = f.to_f
    end
  end

  def set_power_reserves_percent( p )
    if p.to_f >= 0.0 and p.to_f <= 100.0
      @power_reserves_percent = p.to_f
    end
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

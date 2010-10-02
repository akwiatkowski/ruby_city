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
  end

  def next_turn
    unless contract_valid?
      sing_new_contract
    end
  end

  # If contract is valid at this moment
  def contract_valid?
    return false if contract_to.nil? or contract_to < city.simulation.time
    return true
  end

  def sing_new_contract
    @contract = @ai.select_plants_per_power(
      potential_energy_demand,
      @ecological_factor,
      0.0 # tech level
    )
    @contract[:valid_to] = city.simulation.time + Options::ENERGY_CONTRACT_TIME
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



  #  def process_http_request( action, param )
  #    # TODO before finish change http comm to self protocol
  #    case action
  #    when 'set_tax' then set_tax( param )
  #    else false
  #    end
  #  end
  #
  #  def generate_html_action
  #    str = ""
  #
  #    str += "Set taxes: "
  #    tax_numeric = (tax * 100).floor
  #
  #    [-5, -2, -1, 1, 2, 5].each do |a|
  #      if ( tax_numeric + a ) >= 0 and (tax_numeric + a ) <= 100
  #        str += "<a href=\"/#{city.id}/finance/set_tax/#{tax_numeric + a}\">#{tax_numeric + a}</a> "
  #      end
  #    end
  #
  #    return str
  #  end
  #
  #  def set_tax( tax_new )
  #    if tax_new.to_i >= 0 and tax_new.to_i <= 100
  #      @tax = tax_new.to_f / 100.0
  #    end
  #  end

end

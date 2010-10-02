require 'lib/city_infrastructure'
require 'lib/ai_powerplant'

class CityInfrastructureEnergy < CityInfrastructure

  attr_reader :city

  def initialize( *args )
    super( *args )

    @ai = AiPowerplant.new( self )

    # type of fuel/contractor
    @contract_type = nil
    # contract is valid to
    @contract_due = nil
    # amount of units for contract
    @contract_units = 0
  end

  def sing_new_contract
    @ai.select_plants( 100, 0.0 )
  end

  # Contracted power
  def energy

  end

  # Calculate energy created by power plants
  def energy_demand
    Options::ENERGY_NEEDED_PER_CITY.call( city, city.simulation )
  end

  # Calculate energy potential demand (full capacity, winter season)
  def potential_energy_demand
    Options::ENERGY_POTENTIAL_DEMAND_PER_CITY.call( city, city.simulation )
  end

  def maintance_cost
    # TODO
    return 0
  end

  def generate_html_report
    "
<h2>Energy</h2>
Energy demand: <b>#{energy_demand}</b><br />
Potential energy demand: <b>#{potential_energy_demand}</b><br />
Maintance cost: <b>#{maintance_cost}</b><br />
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

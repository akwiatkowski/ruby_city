require 'lib/city_infrastructure'

class CityInfrastructureEnergy < CityInfrastructure

  def initialize( *args )
    super( *args )
    @powerplants = []
  end


  # Calculate energy created by power plants
  def energy
    # TODO
    return 0
  end

  def maintance_cost
    # TODO
    return 0
  end

  def generate_html_report
    "
<h2>Energy</h2>
Energy: <b>#{energy}</b><br />
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

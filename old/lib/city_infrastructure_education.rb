require './lib/city_infrastructure'

class CityInfrastructureEducation < CityInfrastructure
  EDUCATION_LEVEL_CHANGE_SPEED_COEF = 0.2

  attr_reader :education_level, :spending_percent, :tech_level

  def initialize( *args )
    super( *args )
    # 0 - 100 of taxes
    @spending_percent = Options::EDUCATION_INITIAL_LEVEL
    @residential = @city.residential
    # 0 - 100
    @education_level = Options::EDUCATION_LEVEL_WITHOUT_SPENING
    # 0 - inf
    @tech_level = 0.0
  end

  def next_turn
    pay_spending
    modify_education_level
    increase_tech_level
  end

  def pay_spending
    @city.finance.add_finance_percentage_operation( -1.0 * @spending_percent, :education_spending )
  end

  def increase_tech_level
    inc_abs = Options::EDUCATION_INCREAMENT_TECH_LEVEL.call(
      @education_level,
      @spending_percent,
      city.finance.find_last_turn_operation_flow( :education_spending ),
      @residential.population
    )
    @tech_level = Options::EDUCATION_UPDATE_TECH_LEVEL.call( @tech_level, inc_abs )
  end

  def modify_education_level
    @education_level = Options::EDUCATION_EVAL_NEW_LEVEL.call(
      @education_level,
      @spending_percent,
      city.finance.find_last_turn_operation_flow( :education_spending ),
      @residential.population
    )

    if @education_level > 100
      @education_level = 100
    end
    if @education_level < 0
      @education_level = 0
    end

    return @education_level
  end

  def generate_html_report
    "
<h2>Education</h2>
spending: <b>#{spending_percent} %</b><br />
Education level: <b>#{education_level}</b><br />
Tech level: <b>#{tech_level}</b><br />
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
      if ( spending_percent + a ) >= 0 and (spending_percent + a ) <= 100
        str += "<a href=\"/#{city.id}/education/set_spending/#{spending_percent + a}\">#{spending_percent + a} %</a> "
      end
    end
  
    return str
  end
  
  def set_spending( spending_new )
    if spending_new.to_i >= 0 and spending_new.to_i <= 100
      @spending_percent = spending_new.to_i
    end
  end

end

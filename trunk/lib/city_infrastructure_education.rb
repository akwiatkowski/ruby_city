require 'lib/city_infrastructure'

class CityInfrastructureEducation < CityInfrastructure
  EDUCATION_LEVEL_CHANGE_SPEED_COEF = 0.2

  attr_reader :education_level, :funding_percent

  def initialize( *args )
    super( *args )
    # 0 - 100 of taxes
    @funding_percent = Options::EDUCATION_INITIAL_LEVEL
    @residential = @city.residential
    # 0 - 100
    @education_level = Options::EDUCATION_LEVEL_WITHOUT_SPENING
  end

  def next_turn
    pay_funding
    modify_education_level
  end

  def pay_funding
    @city.finance.add_finance_percentage_operation( -1.0 * @funding_percent, :education_funding )
  end

  def modify_education_level
    @education_level = Options::EDUCATION_EVAL_NEW_LEVEL.call(
      @education_level,
      @funding_percent,
      city.finance.find_last_turn_operation_flow( :education_funding ),
      @residential.population )

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
Funding: <b>#{funding_percent} %</b><br />
Education level: <b>#{education_level}</b><br />
    "
  end


  

  def process_http_request( action, param )
    # TODO before finish change http comm to self protocol
    case action
    when 'set_funding' then set_funding( param )
    else false
    end
  end
  
  def generate_html_action
    str = ""
  
    str += "Set funding: "
  
    [-5, -2, -1, 1, 2, 5].each do |a|
      if ( funding_percent + a ) >= 0 and (funding_percent + a ) <= 100
        str += "<a href=\"/#{city.id}/education/set_funding/#{funding_percent + a}\">#{funding_percent + a} %</a> "
      end
    end
  
    return str
  end
  
  def set_funding( funding_new )
    if funding_new.to_i >= 0 and funding_new.to_i <= 100
      @funding_percent = funding_new.to_i
    end
  end

end

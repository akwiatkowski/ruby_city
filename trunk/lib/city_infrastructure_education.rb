require 'lib/city_infrastructure'

class CityInfrastructureEducation < CityInfrastructure
  INITIAL_EDUCATION_FUNDING_PERCENT = 0
  STANDARD_EDUCATION_LEVEL = 0
  EDUCATION_LEVEL_CHANGE_SPEED_COEF = 0.2

  attr_reader :education_level, :funding_percent

  def initialize( *args )
    super( *args )
    # 0 - 100 of taxes
    @funding_percent = INITIAL_EDUCATION_FUNDING_PERCENT
    @residential = @city.residential
    # 0 - 100
    @education_level = STANDARD_EDUCATION_LEVEL
  end

  def next_year
    pay_funding
    modify_education_level
  end

  def pay_funding
    @city.finance.add_finance_percentage_operation( @funding_percent, :education_funding )
  end

  def modify_education_level
    target_educational_level = @funding_percent
    level_change = (target_educational_level - @education_level).to_f * EDUCATION_LEVEL_CHANGE_SPEED_COEF.to_f
    @education_level += level_change

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

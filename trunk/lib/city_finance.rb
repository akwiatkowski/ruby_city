require 'lib/city_base_class'

# Financial setting abouc city

class CityFinance < CityBaseClass

  DEFAULT_BALACE = 100.0

  attr_reader :tax, :balance

  def initialize( *args )
    super( *args )
    @balance = DEFAULT_BALACE
    @tax = 0.1
    # array for all earnings and expenditures
    @current_operatons = []
  end

  def generate_html_report
    "
<h2>Finance</h2>
Balance: <b>#{@balance}</b><br />
Tax: <b>#{@tax}</b><br />
    "
  end



  def process_http_request( action, param )
    # TODO before finish change http comm to self protocol
    case action
    when 'set_tax' then set_tax( param )
    else false
    end
  end

  def generate_html_action
    str = ""

    str += "Set taxes: "
    tax_numeric = (tax * 100).floor
    
    [-5, -2, -1, 1, 2, 5].each do |a|
      if ( tax_numeric + a ) >= 0 and (tax_numeric + a ) <= 100
        str += "<a href=\"/#{city.id}/finance/set_tax/#{tax_numeric + a}\">#{tax_numeric + a}</a> "
      end
    end
    
    return str
  end

  def set_tax( tax_new )
    if tax_new.to_i >= 0 and tax_new.to_i <= 100
      @tax = tax_new.to_f / 100.0
    end
  end





  # TODO use special object for amount, so it should be hard to use this fuction
  # not within proper methods
  #def increase_balance( amount, why = :unknown )
  #  @balance += amount
  #  return @balance
  #end

  def increase_balance_tax( amount, type = :unknown )
    @current_operatons << {:amount => amount, :type => type}
    return true
  end

  #def decrease_balance( amount, why = :unknown )
  #  @balance -= amount
  #  return @balance
  #end

  # Calculate balance from all registered operations
  # Done only at the enf of year
  def process_operation
    balance_change = 0.0
    # sum up all amount earning
    @current_operatons.each do |op|
      if not op[:amount].nil? and op[:amount] >= 0.0
        balance_change += op[:amount]
      end
    end
    # sum up all amount expenditures
    @current_operatons.each do |op|
      if not op[:amount].nil? and op[:amount] < 0.0
        balance_change += op[:amount]
      end
    end

    # sum up percentage earning - probably none :]
    percent_up = 0.0
    @current_operatons.each do |op|
      if not op[:percent].nil? and op[:percent] >= 0.0
        percent_up += op[:percent]
      end
    end
    # sum up percentage exp. - like education, healtcare, ...
    percent_down = 0.0
    @current_operatons.each do |op|
      if not op[:percent].nil? and op[:percent] < 0.0
        percent_down += op[:percent]
      end
    end

    balance_change *= (1 + percent_up.to_f / 100.0)
    balance_change *= (1 - percent_up.to_f / 100.0)

    @balance += balance_change
  end


end

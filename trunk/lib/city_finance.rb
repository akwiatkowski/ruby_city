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
    @last_year_operations = []
  end

  def next_year
    process_operation
  end

  def generate_html_report
    str = "
<h2>Finance</h2>
Balance: <b>#{@balance}</b><br />
Tax: <b>#{@tax}</b><br />
    "

    # last year operations
    str += "<div style=\"font-size: 10px;\"><ul>"
    @last_year_operations.each do |op|
      str += "<li> "
      str += "+" if op[:amount] >= 0.0
      str += "#{op[:amount]} "
      str += "(#{op[:percent]} %)" unless op[:percent].nil?
      str += " - #{op[:type]} </li>"
    end
    str += "</ul></div>"

    return str
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

  # Operation is processed now
  def add_finance_operation_now( amount, type = :unknown )
    # TODO if not enough money?
    @balance += amount
    @current_operatons << {:amount_done => amount, :amount => 0.0, :type => type}
    return true
  end

  # Operation will be processed at end of year
  def add_finance_operation( amount, type = :unknown )
    @current_operatons << {:amount => amount, :type => type}
    return true
  end

  def add_finance_percentage_operation( percent, type = :unknown )
    @current_operatons << {:percent => percent, :type => type}
    return true
  end

  #def decrease_balance( amount, why = :unknown )
  #  @balance -= amount
  #  return @balance
  #end

  # Return all operations from last year with chosen type
  def find_last_year_operation( type )
    # clone - can not change
    return @last_year_operations.select{|op| op[:type] == type }.clone
  end

  # Return sum of all operations, amount and percentage
  def find_last_year_operation_flow( type )
    ops = find_last_year_operation( type )
    puts ops.to_yaml
    sum = 0 + ops.collect{|op| op[:amount]}.sum.to_i
    return sum
  end

  # Calculate balance from all registered operations
  # Done only at the enf of year
  def process_operation

    # sum up all amount earning
    amount_earnings = 0.0
    @current_operatons.each do |op|
      if not op[:amount].nil? and op[:amount] >= 0.0 and not true == op[:done]
        amount_earnings += op[:amount]
        op[:done] = true
      end
    end
    # sum up all amount expenditures (in negative value)
    amount_expenditures = 0.0
    @current_operatons.each do |op|
      if not op[:amount].nil? and op[:amount] < 0.0 and not true == op[:done]
        amount_expenditures += op[:amount]
        op[:done] = true
      end
    end

    # balance change calculated for fixed amounts
    amount_balance_change = amount_earnings + amount_expenditures


    # calculate percentage earnings - probably none :]
    amount_earnings_by_percent = 0.0
    @current_operatons.each do |op|
      if not op[:percent].nil? and op[:percent] >= 0.0 and not true == op[:done]
        # calculate amount
        op[:amount] = op[:percent].to_f * amount_balance_change / 100.0
        op[:amount] = 0.0 if amount_balance_change <= 0.0 # without income can not calculate
        amount_earnings_by_percent += op[:amount]
        op[:done] = true
      end
    end
    # sum up percentage exp. - like education, healthcare, ...
    amount_expenditures_by_percent = 0.0
    @current_operatons.each do |op|
      if not op[:percent].nil? and op[:percent] < 0.0 and not true == op[:done]
        # calculate amount
        op[:amount] = op[:percent].to_f * amount_balance_change / 100.0
        op[:amount] = 0.0 if amount_balance_change <= 0.0 # without income can not calculate
        amount_expenditures_by_percent += op[:amount]
        op[:done] = true
      end
    end

    # summ all operations
    balance_change = amount_balance_change + amount_earnings_by_percent + amount_expenditures_by_percent

    # move all operation to history
    @last_year_operations = @current_operatons
    # clean list
    @current_operatons = Array.new
    # calculate current balance
    @balance += balance_change
  end


end

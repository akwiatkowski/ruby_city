require 'lib/city_base_class'

# Financial setting abouc city

class CityFinance < CityBaseClass

  DEFAULT_BALACE = 100.0

  attr_reader :tax

  def initialize( *args )
    super( *args )
    @balance = DEFAULT_BALACE
    @tax = 0.1
  end

  def generate_html_report
    "
<h2>Finance</h2>
Balance: <b>#{@balance}</b><br />
Tax: <b>#{@tax}</b><br />
    "
  end

end

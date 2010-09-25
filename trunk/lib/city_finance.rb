require 'lib/city_base_class'

# Financial setting abouc city

class CityFinance < CityBaseClass

  attr_reader :tax

  def initialize( *args )
    super( *args )
    @tax = 0.1
  end
end

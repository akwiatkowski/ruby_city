require 'lib/city_residential'
require 'lib/city_finance'
require 'yaml'

class City

  attr_reader :finance, :residential, :simulation

  def initialize( simulation )
    @simulation = simulation
    @residential = CityResidential.new( self )
    @finance = CityFinance.new( self )

    @hash = {
      :residential => @residential,
      :finance => @finance
    }

    @balance = 0.0

    # years from creating this city
    @year = 0

  end

  # Calculate all factors in next year
  def next_year
    @residential.next_year

    @year += 1
  end

  # Add taxes, ...
  def add_income( income )
    @balance += income
    return @balance
  end

  # Information about city status
  def info
    puts self.to_yaml
    puts "\n\n"
  end

  # HTML report for debug
  def generate_html_report
    report = ""
    @hash.each_value do |v|
      report += v.generate_html_report + "<br />"
    end
    return report
  end


  


  #  def next_year
  #    # podatki
  #    @money += @population * 0.50
  #
  #    # przyrost ludzi
  #    @population += 1 if @population <= @residential_capacity
  #  end

  

  
end

require 'lib/city_residential'
require 'lib/city_finance'
require 'yaml'

class City

  attr_reader :finance, :residential

  def initialize
    @residential = CityResidential.new( self )
    @finance = CityFinance.new( self )

    # years from creating this city
    @years_from_start = 0

  end

  # Calculate all factors in next year
  def next_year
    @years_from_start += 1
  end

  # Information about city status
  def info
    puts self.to_yaml
    puts "\n\n"
  end

  # HTML report for debug
  def generate_html_report
    return self.to_yaml.gsub(/\n/, "<br />")

    report = ""
    (0...(@cities.size)).each do |i|
      report += "City: <b>#{i}</b><br />"
      report += @cities[i].generate_html_report
      report += "<hr /><br />"
    end
  end


  


  #  def next_year
  #    # podatki
  #    @money += @population * 0.50
  #
  #    # przyrost ludzi
  #    @population += 1 if @population <= @residential_capacity
  #  end

  

  
end

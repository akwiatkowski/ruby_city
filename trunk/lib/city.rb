require 'lib/city_residential'
require 'lib/city_finance'
require 'lib/city_infrastructure_energy'
require 'lib/city_infrastructure_education'
require 'lib/utils'
require 'yaml'

class City

  attr_reader :finance, :residential, :simulation, :id

  def initialize( simulation, id )
    @simulation = simulation
    @id = id

    @residential = CityResidential.new( self )
    @finance = CityFinance.new( self )
    @energy = CityInfrastructureEnergy.new( self )
    @education = CityInfrastructureEducation.new( self )

    @hash = {
      :residential => @residential,
      :finance => @finance,
      :energy => @energy,
      :education => @education
    }

    @array = [
      @residential,
      @finance,
      @energy,
      @education
    ]

    # years from creating this city
    @year = 0

  end

  # Calculate all factors in next year
  def next_year
    #@residential.next_year
    @array.each do |div|
      div.next_year
    end

    @year += 1
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
      report += v.generate_html_action + "<br />"
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

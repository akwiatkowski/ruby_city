require 'lib/city_residential'
require 'lib/city_finance'
require 'lib/city_infrastructure_energy'
require 'lib/city_infrastructure_education'
require 'lib/city_bad_factors'
require 'lib/utils'
require 'yaml'

class City

  attr_reader :finance, :residential, :simulation, :energy, :id,
    :hash, :array

  def initialize( simulation, id )
    @simulation = simulation
    @id = id

    @residential = CityResidential.new( self )
    @finance = CityFinance.new( self )
    @energy = CityInfrastructureEnergy.new( self )
    @education = CityInfrastructureEducation.new( self )
    @bad_factors = CityBadFactors.new( self )

    @hash = {
      :residential => @residential,
      :finance => @finance,
      :energy => @energy,
      :education => @education,
      :bad_factors => @bad_factors
    }

    @array = [
      @residential,
      @finance,
      @energy,
      @education,
      @bad_factors
    ]

    @started_time = @simulation.time
  end

  # Calculate all factors in next year
  def next_turn
    #@residential.next_year
    @array.each do |div|
      div.next_turn
    end

    @time = @simulation.time
  end

  # Information about city status
  def info
    puts self.to_yaml
    puts "\n\n"
  end

  # HTML report for debug
  def generate_html_report
    report = ""
    @array.each do |v|
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

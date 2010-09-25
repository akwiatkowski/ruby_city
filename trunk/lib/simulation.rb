require 'lib/city'
require 'lib/simulation_server'
require 'lib/simulation_web_server'
require 'yaml'

class Simulation

  attr_reader :year

  def initialize
    @server = SimulationServer.new( self, SimulationServer::PORT )
    @server.start

    @web_server = SimulationWebServer.new( self )
    @web_server.start

    @cities = Array.new
    @cities << City.new( self )
    
    @year = 0
  end

  def process_server_command( command )
    return 'test'
  end

  def start_simulation
    loop do

      @cities.each do |c|
        c.info
        c.next_year
      end

      @year += 1
      sleep(1)
    end
  end

  def generate_html_report
    report = ""
    (0...(@cities.size)).each do |i|
      report += "City ID: <b>#{i}</b><br />"
      report += @cities[i].generate_html_report
      report += "<hr /><br />"
    end
    return report
  end


end

require 'lib/city'
require 'lib/simulation_server'
require 'lib/simulation_web_server'
require 'yaml'

class Simulation
  def initialize
    @server = SimulationServer.new( self, SimulationServer::PORT )
    @server.start

    @web_server = SimulationWebServer.new( self )
    @web_server.start

    @cities = Array.new
    @cities << City.new
    
    @years_from_start = 0
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
      
      sleep(1)
    end
  end

  def generate_html_report
    report = ""
    (0...(@cities.size)).each do |i|
      report += "City: <b>#{i}</b><br />"
      report += @cities[i].generate_html_report
      report += "<hr /><br />"
    end
    return report
  end


end

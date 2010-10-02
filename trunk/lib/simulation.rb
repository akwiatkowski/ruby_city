require 'lib/utils'
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
    @cities << City.new( self, @cities.size )
    
    @year = 0

    Thread.abort_on_exception =  true
  end

  def process_server_command( command )
    return 'test'
  end

  def process_http_request( city_id, division_name, action, param )
    city = @cities[city_id]
    division = city.instance_variable_get("@#{division_name}".to_sym)

    # http://localhost:8080/0/residential/increase/10
    division.process_http_request( action, param )
  end

  def start_simulation
    loop do

      @cities.each do |c|
        #c.info
        c.next_year
      end

      @year += 1
      sleep(1)
    end
  end

  def generate_html_report
    report = ""
    report += "<h1>RubyCity</h1>"
    report += "<h2>HTML report @ year #{@year}</h2>"
    report += "<hr />"

    (0...(@cities.size)).each do |i|
      report += "City ID: <b>#{i}</b><br />"
      report += @cities[i].generate_html_report
      report += "<hr /><br />"
    end
    return report
  end


end

# Simple server to show status of game

require 'lib/simple_web_server'

class SimulationWebServer
  include SimpleWebServer

  def initialize(simulation)
    @simulation = simulation
  end

  def process_request
    @simulation.generate_html_report
  end

end

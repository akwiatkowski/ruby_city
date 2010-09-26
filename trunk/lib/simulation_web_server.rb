# Simple server to show status of game

require 'lib/simple_web_server'

class SimulationWebServer
  include SimpleWebServer

  def initialize(simulation)
    @simulation = simulation
  end

  def process_request( connection )
    request_ouput = decode_request( connection.gets )
    @simulation.generate_html_report
  end

  private

  def decode_request( request )
    #if request =~ /http:\/\/[^\/]*\/([^\/]*)\/([^\/]*)\/([^\/]*)\/([^\/]*)/
    if request =~ /GET \/([^\/]*)\/([^\/]*)\/([^\/]*)\/([^\/]*)\/([^\/]*)/
      city_id = $1.to_i
      division = $2
      action = $3
      param = $4

      @simulation.process_http_request(
        city_id,
        division,
        action,
        param
      )
      puts "process request: #{$1}, #{$2}, #{$3}, #{$4}"
    else
      puts request
    end
    
  end

end

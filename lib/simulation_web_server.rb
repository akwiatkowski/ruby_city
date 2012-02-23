# Simple server to show status of game

require './lib/simple_web_server'

class SimulationWebServer
  include SimpleWebServer

  def initialize(simulation)
    @simulation = simulation
  end

  def process_request( connection )
    request_ouput = decode_request( connection.gets )
    str = @simulation.generate_html_report
    str += @simulation.generate_html_action
    str += request_ouput.to_s
    return str
  end

  private

  def decode_request( request )
    #if request =~ /http:\/\/[^\/]*\/([^\/]*)\/([^\/]*)\/([^\/]*)\/([^\/]*)/
    if request =~ /GET \/([^\/]*)\/([^\/]*)\/([^\/]*)\/([^\/]*)\/([^\/]*)/
      city_id = $1.to_i
      division = $2
      action = $3
      param = $4

      resp = @simulation.process_http_request(
        city_id,
        division,
        action,
        param
      )
      puts "process request: #{city_id}, #{division}, #{action}, #{param}"
      puts request
      return resp

    elsif request =~ /GET \/([^\/]*)\/([^\/]*)\/([^\/ ]*)/ and $1 == "simulation"
      # simulation request
      action = $2
      param = $3

      resp = @simulation.process_http_request_for_simulation(
        action,
        param
      )
      puts "process simulation request: #{action}, #{param}"
      return resp
    else

      puts "bad request, request #{request}"
      return nil
    end
    
  end

end

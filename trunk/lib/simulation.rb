require 'lib/utils'
require 'lib/city'
require 'lib/simulation_server'
require 'lib/simulation_web_server'
require 'yaml'

class Simulation

  attr_reader :time

  def initialize
    @server = SimulationServer.new( self, SimulationServer::PORT )
    @server.start

    @web_server = SimulationWebServer.new( self )
    @web_server.start

    @cities = Array.new
    @cities << City.new( self, @cities.size )
    
    @time = Time.now

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

  def process_http_request_for_simulation( action, param )
    # http://localhost:8080/simulation/save/a
    case action
    when 'save' then simulation_save( param )
    when 'load' then simulation_load( param )
    else false
    end
  end

  def generate_html_action
    str = ""
    str += "<a href=\"/simulation/save/savegame1\">Save simulation %</a><br /> "
    str += "<a href=\"/simulation/load/savegame1\">Load simulation %</a><br /> "

    return str
  end


  def start_simulation
    loop do

      @cities.each do |c|
        #c.info
        c.next_turn
      end

      @time += Options::SIMULATION_TURN_TIME
      sleep( Options::SIMULATION_TURN_REAL_TIME )
    end
  end

  def generate_html_report
    report = ""
    report += "<h1>RubyCity</h1>"
    report += "<h2>HTML report @ time #{@time.to_s_human_date}</h2>"
    report += "<hr />"

    (0...(@cities.size)).each do |i|
      report += "City ID: <b>#{i}</b><br />"
      report += @cities[i].generate_html_report
      report += "<hr /><br />"
    end
    return report
  end

  private

  def simulation_save( file )
    data = {
      :cities => @cities,
      :time => @time
    }

    File.open( save_path( file ), "w"){ |file| file.puts(data.to_yaml) }
  end

  def simulation_load( file )
    data = YAML::load_file( save_path( file ) )
    @cities = data[:cities]
    @time = data[:time]
  end

  def save_path( file )
    "data/saves/#{file}"
  end


end

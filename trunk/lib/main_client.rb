require 'lib/comm'
require 'lib/city_server'

comm = Comm.new
res = comm.send_to_server(:test, CityServer::PORT )
puts res
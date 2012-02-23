require 'socket'

module SimpleWebServer

  def start
    @server = TCPServer.new(8080)
    t = Thread.new{ listen }
  end

  # Output of server
  def process_request( connection )
    return "OK"
  end

  private

  def listen
    while connection = @server.accept
      #      headers = []
      #      length  = 0
      #
      #      while line = connection.gets
      #        headers << line
      #
      #        if line =~ /^Content-Length:\s+(\d+)/i
      #          length = $1.to_i
      #        end
      #
      #        break if line == "\r\n"
      #      end

      #      body = connection.readpartial(length) + "test"
      #      IO.popen(ARGV[0], 'r+') do |script|
      #        script.print(headers.join + body)
      #        script.close_write
      #        connection.print script.read
      #      end

      header = "HTTP/1.1 200/OK\r\nContent-type: text/html\r\n\r\n"

      connection.print header + process_request( connection )
      connection.close
    end
  end
end






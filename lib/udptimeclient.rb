require 'socket'

class UDPTimeClient
  attr_reader :hostname
  attr_reader :port_number

  def initialize(hostname, port_number)
    @hostname = hostname
    @port_number = port_number
  end

  def send_request(request)
    socket = UDPSocket.new
    socket.connect(self.hostname, self.port_number)
    socket.write(request)
    response = socket.gets
    return response
  end
end

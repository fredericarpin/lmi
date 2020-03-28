require 'socket'
require 'commandprocessor'

class UDPTimeServer
  attr_reader :hostname
  attr_reader :port_number

  def initialize(hostname, port_number)
    @hostname = hostname
    @port_number = port_number
    @socket = UDPSocket.new
    @socket.bind(self.hostname, self.port_number)
  end

  def run
    @threads = []
    loop do
      @threads << Thread.start(@socket.recvfrom(128)) do |request, peer|
        puts "UDP request: #{request}"
        @socket.send(CommandProcessor.process(request.chomp), 0, peer[3], peer[1])
      end
    end
  end

end

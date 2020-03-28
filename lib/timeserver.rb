require 'tcptimeserver'
require 'udptimeserver'

class TimeServer
  attr_reader :hostname
  attr_reader :port_number

  def initialize(hostname, port_number)
    @hostname = hostname
    @port_number = port_number
  end

  def run
    threads = []
    threads << Thread.new { TCPTimeServer.new(self.hostname, self.port_number).run }
    threads << Thread.new { UDPTimeServer.new(self.hostname, self.port_number).run }
    threads.each { |thread| thread.join }
  end
end

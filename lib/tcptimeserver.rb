require 'socket'
require 'commandprocessor'

class TCPTimeServer
  attr_reader :hostname
  attr_reader :port_number

  def initialize(hostname, port_number)
    @hostname = hostname
    @port_number = port_number
    @server = TCPServer.new(self.hostname, self.port_number)
    @timeout_seconds = 5
  end

  def run
    @threads = []
    loop do
      @threads << Thread.start(@server.accept) do |client|
        stop = false
        request = ""
        timer = Time.now
        until stop
          begin
            if client.recv_nonblock(1, Socket::MSG_PEEK)
              timer = Time.now
              received_character = client.recv(1)
              request << received_character
              if received_character == "\n"
                if request.chomp! == ""
                  stop = true
                else
                  client.write(CommandProcessor.process(request))
                end
              end
            else
            end
          rescue IO::EAGAINWaitReadable
            sleep 0.2
            if Time.now - timer > @timeout_seconds
              client.write("Idle for more than #{@timeout_seconds} seconds, closing connection\n")
              stop = true
            end
          end
        end
        client.close
      end
    end
  end
end

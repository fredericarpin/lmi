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
      # begin
        @threads << Thread.start(@server.accept) do |client|
          stop = false
          request = ""
          until stop
            client.recv(1, Socket::MSG_PEEK)
            received_character = client.recv(1)
            request << received_character
            if received_character == "\n"
              if request.chomp! == ""
                stop = true
              else
                client.write(CommandProcessor.process(request))
              end
            end
          end
          client.close
        end
      # rescue Exception

      # end
    end
  end

  def terminate

  end
end

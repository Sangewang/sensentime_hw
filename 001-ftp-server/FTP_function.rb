require 'socket'
require './FTP_function'
module MYFTP
  class MultiProcess
    CRLF = "\r\n"
    def initialize(port=21)
      @control_socket = TCPServer.new(port)
      trap(:INT) {exit}
    end

    def gets
      @client.gets(CRLF)
    end

    def respond(message)
      @client.write(message)
      @client.write(CRLF)
    end

    def run
      loop do
        @client = @control_socket.accept
        pid = fork do
          respond "220 new client"


          handler = FTP_function.new(self)
        
          loop do
            request = gets

            if request
              respond handler.handle(request)
            else
              @client.close
              break
            end
          end
        end

        Process.detach(pid)
      end
    end
  end
end

server = MYFTP::MultiProcess.new(4481)
server.run



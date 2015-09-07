
require 'socket'
require './FTP_function'
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'logger'

module MYFTP
 class MultiProcess

  def self.parse(args)
    options = OpenStruct.new()
    options.port = 6789
    options.host = '0.0.0.0'
    options.dir = `echo $HOME`.delete!("\n")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: 001-ftp-server/myftp.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-p", "--port=PORT", "listen port") do |port|
        if port.to_i.ia_a?(Fixnum) && port.to_i>1023 && port.to_i <65535
          options.port = port
        else
          puts "Invalid port number,using default port instead."
        end
      end
      opts.on("--host=HOST","binding address")  do |host|
         addr_list = ["localhost","0.0.0.0"]
      end

      opts.on("--dir=DIR","change current directory") do |dir|
      end

      opts.on_tail("-h", "print help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end  # parse()


    CRLF = "\r\n"
    def initialize(port=21)
      options=self.class.parse(ARGV)
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




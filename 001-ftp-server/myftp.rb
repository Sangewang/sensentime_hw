require 'socket'
module MYFTP
  class FTP_function
    CRLF = "\r\n"
    attr_reader :connection
   
    def initialize(connection)
      @connection = connection
    end

    def pwd
      @pwd || Dir.pwd
    end

    def handle(data)
      puts ("data=#{data}")
      cmd = data[0..3].strip.upcase
      puts ("cmd=#{cmd}")
     
      options = data[4..-1].strip
      puts ("options=#{options}")


      case cmd
      when 'USER'
        
        "230 Logged in anonymously"

      when 'SYST'
        "215 LINUX Working With FTP"

      when 'CWD'
          if File.directory?(options)
             @pwd = options
            "250 directory changed to #{pwd}"
         else
             "550 directory not found"
         end

      when 'PWD'
          puts("PWD Command")
           "257 \"#{pwd}\" is the current directory"

      when 'PORT'|| 'PASV'
          parts = options.split(',')
          puts("parts=#")
          ip_address = parts[0..3].join('.')
          puts("ip_address=#{ip_address}")
          port = Integer(parts[4])*256 + Integer(parts[5])
          puts ("port=#{port}")
          @data_socket=TCPSocket.new(ip_address,port)
         
         "227 Active connection established (#{port})"
     when 'TYPE'
          option = "A"
          @data_socket=TCPServer.open(0)     
           "200 Active connection established (#{port})"

     when 'RETR'
          puts("PETR Command")
          if(File.exists?(options)) 
              file=File.open(File.join(pwd,options),'r')
              connection.respond "125 Data transfer starting "
              bytes = IO.copy_stream(file,@data_socket)
              @data_socket.close
              "226 Closing data connection,sent #{bytes} bytes"
          else
            "No Match File,Please Confirm!!"
          end
      when  'LIST'
          connection.respond "125 Opening data connection for file list"
          result = Dir.entries(pwd).join(CRLF)
          
          @data_socket.write(result)
          @data_socket.close
          "226 Closing data connection,sent #{result.size} bytes"
      when 'QUIT'
          puts("QUIT Command")
          puts "221 Stop Connection!"
          exit;
     when 'STOR'
        #  if(File.exists?(options))
             puts options
             connection.respond "150 Data transfer starting "
             file=File.new(options,'w')
             file.syswrite(@data_socket.read)

             @data_socket.close
             "226 Closing data conenction,sent #{bytes} bytes"
        # else
        #     "No Match File,Please Confirm!!"
        # end
     else 
          puts("502...Command")
          "502 unknown #{cmd}"
      end
    end
  end
end


        





require 'socket'
require 'securerandom'
require_relative './message'
require 'pry'

# class HeartBeat < Message
# 
#   def max_schema
#     3
#   end
# 
#   def version
#     "Qt_5_4"
#   end
# 
#   def revision
#     "16"
#   end
# 
#   def id
#     @id = "ruby-client" #||= SecureRandom.uuid
#   end
# 
#   def payload
#     [
#       0,
#       id.bytesize,
#       id,
#       max_schema,
#       version.bytesize,
#       version,
#       revision.bytesize,
#       revision
#     ].pack "NNa#{id.bytesize}NNa#{version.bytesize}Na#{revision.bytesize}"
#   end
# 
#   def self.from_socket(socket)
#     # read the heartbeat packet from the socket
#     # utf8 Id
#     # uint32 max_schema_number
#     # utf8 version
#     # utf8 revision
#     # utf8 is
#   end
# end

class Client
  attr_reader :address, :port

  def initialize(address, port)
    @address = address
    @port = port
  end

  def listen
    @c = UDPSocket.new
    heartbeat = HeartBeat.new
    @c.bind address, port
    puts "sending heartbeat: #{heartbeat.to_packed.inspect}"
    #@c.send(heartbeat.to_packed, 0)
    #puts "sent hearthbeat:"
    while true do
      x = @c.recv(1000)
    #x = recv
      #puts x.inspect
      puts Message.from_packet(x)
    end
    yield #recv
  ensure
    @c.close
  end

  private

  def recv
   begin # emulate blocking recvfrom
     @c.recvfrom_nonblock(1)  #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
   rescue IO::WaitReadable
     IO.select([@c])
     retry
   end 
  end
end

c = Client.new('127.0.0.1', 2237)

c.listen do |message|
   puts message.inspect
 end

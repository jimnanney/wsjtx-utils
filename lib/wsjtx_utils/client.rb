# frozen_string_literal: true

require "socket"
require "securerandom"

module WsjtxUtils
  class Client
    attr_reader :address, :port

    def initialize(address, port)
      @address = address
      @port = port
    end

    def listen
      @c = UDPSocket.new
      @c.bind address, port
      loop do
        x = @c.recv(1000)
        yield Message.from_packet(x)
      end
    ensure
      @c.close
    end

    private

    def recv
      # emulate blocking recvfrom
      @c.recvfrom_nonblock(1)  #=> ["aaa", ["AF_INET", 33302, "localhost.localdomain", "127.0.0.1"]]
    rescue IO::WaitReadable
      IO.select([@c])
      retry
    end
  end
end

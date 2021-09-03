require 'pry'

module WsjtxUtils
  class Message
    attr_accessor :packet

    MAGIC_NUMBER = 0xadbccbda

    MESSAGE_TYPES = {
      0 => 'HeartbeatMessage'
    }

    def version
      @version ||= 3
    end

    def index
      @index ||= 0
    end

    def header
      [MAGIC_NUMBER, version]
    end

    def to_packed
      header.pack("NN").concat payload
    end

    def payload
      []
    end

    def self.from_packet(packet)
      magic, version, packet_type = packet.unpack('NNN')
      Object.const_get("WsjtxUtils::#{MESSAGE_TYPES.fetch(packet_type, 'UnknownMessage')}").from_packet(packet)
    end

    def to_s
      "#{self.class.name} - #{packet.inspect}"
    end

    def decode_int
      current(4).unpack1('N')
    end

    def decode_string
      size = decode_int
      return nil unless size
      current(size).unpack1("a#{size}")
    end

    private

    def current(size)
      return '' unless packet
      return '' if (index + size) > packet.length
      @index = index + size
      packet.byteslice((index-size)..)
    end
  end
end


module WsjtxUtils
  class Message
    attr_accessor :packet

    MESSAGE_TYPES = {
      0 => 'HeartbeatMessage'
    }

    def header
      [0xadbccbda, 3]
    end

    def to_packed
      header.pack("NN").concat payload
    end

    def payload
      []
    end

    def self.from_packet(packet)
      magic, version, packet_type = packet.unpack('NNC')
      Object.const_get("WsjtxUtils::#{MESSAGE_TYPES.fetch(packet_type, 'UnknownMessage')}").from_packet(packet)
    end

    def to_s
      "#{self.class.name} - #{packet.inspect}"
    end
  end
end


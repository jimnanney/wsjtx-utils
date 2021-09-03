# frozen_string_literal: true

module WsjtxUtils
  class HeartbeatMessage < Message
    attr_accessor :schema, :version, :revision, :id

    def self.from_packet(packet)
      new.tap do |c|
        c.packet = packet
        c.decode_packet
      end
    end

    def decode_packet
      decode_int
      decode_int
      decode_int
      @id = decode_string
      @schema = decode_int
      @version = decode_string
      @revision = decode_string
    end
  end
end

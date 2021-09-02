module WsjtxUtils
  class HeartbeatMessage < Message
    attr_accessor :schema, :version,:revision
    def self.from_packet(packet)
      new.tap { |c| c.packet = packet }
    end
  end
end

# frozen_string_literal: true

module WsjtxUtils
  class UnknownMessage < Message
    def self.from_packet(packet)
      new.tap { |c| c.packet = packet }
    end
  end
end

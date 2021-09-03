# frozen_string_literal: true

require "spec_helper"

module WsjtxUtils
  describe HeartbeatMessage do
    it { is_expected.to have_attributes(schema: nil, version: nil, revision: nil, id: nil) }

    describe ".from_packet" do
      let(:heartbeat_packet) do
        [
          Message::MAGIC_NUMBER,
          3, 0, 4, "Test", 3, 1, "Q", 1, "T"
        ].pack("NNNNa4NNa1Na1")
      end

      it "returns a populated Heartbeat message" do
        hb = HeartbeatMessage.from_packet(heartbeat_packet)

        expect(hb).to be_a(HeartbeatMessage)
        expect(hb).to have_attributes(id: "Test", schema: 3, version: "Q", revision: "T")
      end
    end
  end
end

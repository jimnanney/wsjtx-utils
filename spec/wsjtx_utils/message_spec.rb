# frozen_string_literal: true

require "spec_helper"

module WsjtxUtils
  describe Message do # rubocop:disable Metrics/BlockLength
    subject(:message) { described_class.new }

    describe "#header" do
      it "contains the magic number and protocol version" do
        expect(message.header).to match_array([0xadbccbda, 3])
      end
    end

    describe "MESSAGE_TYPES" do
      it "contains a lookup hash of message types stored by the message type id" do
        expect(Message::MESSAGE_TYPES).to include(0 => "HeartbeatMessage")
      end
    end

    describe ".from_packet" do
      context "given a heartbeat message type" do
        let(:heartbeat_packet) { [Message::MAGIC_NUMBER, 3, 0, "id".length, "id"].pack("NNCNa#{"id".bytesize}") }

        it "returns a new instance of the registered message type" do
          result = described_class.from_packet(heartbeat_packet)
          expect(result).to be_a(HeartbeatMessage)
        end
      end

      context "given an unknown message type" do
        let(:unknown_packet) { [Message::MAGIC_NUMBER, 3, 255].pack("NNC") }

        it "returns the Unknown message type" do
          result = described_class.from_packet(unknown_packet)
          expect(result).to be_a(UnknownMessage)
        end
      end
    end

    describe "decoding data" do
      describe "#decode_int" do
        it "decodes an integer from the packet and advances the index by 4" do
          message.packet = [1_000_000].pack("N")

          expect(message.decode_int).to eq(1_000_000)
          expect(message.index).to eq(4)
        end
      end

      describe "#decode_string" do
        it "gets the string size from the current index and then reads that many bytes into a string" do
          string = "Test"
          message.packet = [string.bytesize, string].pack("Na#{string.bytesize}")

          expect(message.decode_string).to eq(string)
          expect(message.index).to eq(4 + string.bytesize)
        end

        it "returns nil if the packet contains no data to unpack" do
          message.packet = ""

          expect(message.decode_string).to eq(nil)
        end
      end
    end
  end
end

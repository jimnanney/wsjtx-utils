require 'spec_helper'

module WsjtxUtils
  describe Message do
    subject(:message) { described_class.new }

    describe '#header' do
      it 'contains the magic number and protocol version' do
        expect(message.header).to match_array([0xadbccbda, 3])
      end
    end

    describe 'MESSAGE_TYPES' do
      it 'contains a lookup hash of message types stored by the message type id' do
        expect(Message::MESSAGE_TYPES).to include(0 => 'HeartbeatMessage')
      end
    end

    describe '.from_packet' do
      context 'given a heartbeat message type' do
        let(:heartbeat_packet) { [0xadbccbda, 3, 0, 'id'.length, 'id'].pack("NNCNa#{'id'.bytesize}") }

        it 'returns a new instance of the registered message type' do
          result = described_class.from_packet(heartbeat_packet)
          expect(result).to be_a(HeartbeatMessage)
        end
      end

      context 'given an unknown message type' do
        let(:unknown_packet) { [0xadbccbda, 3, 255].pack('NNC') }

        it 'returns the Unknown message type' do
          result = described_class.from_packet(unknown_packet)
          expect(result).to be_a(UnknownMessage)
        end
      end
    end
  end
end
